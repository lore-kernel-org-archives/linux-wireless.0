Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52968 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1AXLbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:31:12 -0500
Received: by fxm20 with SMTP id 20so3899436fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 03:31:11 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Survey data inconsistencies between drivers
Date: Mon, 24 Jan 2011 12:29:49 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101241229.50142.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

currently there are at least three different survey types implemented in
different mac80211 drivers.

- ath9k always lists the survey data for all channels and always provides
  accumulated busy time data. This has the advantage that a simple scan
  followed   by a suvrey dump will give a nice overview of the different
  channel utilization.
- ath5k only lists the active channel but also accumlates the busy time
  statistics.
- rt2800 only lists the active channel and only returns relative busy time
  values since the last read.

>From a hw perspective all three drivers appear similar, there are some
registers that are cleared on read and contain the busy times since the
last read.

I really like the ath9k approach but implementing it in every driver
sounds like a lot of redundancy.

In order to have consistent survey data between drivers I'd propose the
following approach:

- The driver's get_survey callback only returns relative survey data for the
  currently active channel. That means reading the current busy time statistics
  from the hw and clearing the appropriate counters.
- mac80211 would keep track of accumulating the gathered survey data.
- mac80211 would read the survey data before each channel change and update
  the approriate channel's survey data just as ath9k does right now.

Any arguments against such a unification?

Thanks,
Helmut
