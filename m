Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:65045 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbZAWNrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 08:47:09 -0500
Received: by yw-out-2324.google.com with SMTP id 9so2146555ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 05:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090123043337.270720@gmx.net>
References: <20090123043337.270720@gmx.net>
Date: Fri, 23 Jan 2009 05:47:06 -0800
Message-ID: <43e72e890901230547w1ca9b24cp632df359e619c980@mail.gmail.com> (sfid-20090123_144715_219044_EF77EAC3)
Subject: Re: [PATCH v2] mac80211: Read the TSF via debugfs
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 8:33 PM, Alina Friedrichsen <x-alina@gmx.net> wrote:
> This patch adds an low-level driver independent entry to read the TSF value into the debugfs of mac80211. This makes debugging the IBSS handling of wifi drivers easier.
>
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

Alina, a few notes on this series. I see you have used the mac80211
ops get_tsf via debugfs, and then added one for ath5k and ath9k. It
would seem a driver-specific get tsf from debugfs is not needed then.
The set_tsf is the only one that seems to be driver specific and could
probably go into their own debugfs.  Anyway how about instead of all
this just adding a new mac80211 ops for set_tsf for mac80211 as well
and then just add nl80211 commands to be able to get/set/reset them?
This way if the driver implements them it'll be through a generic
interface and also we can start using it via iw.

  Luis
