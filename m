Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:38218 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbaEGMGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:06:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by zimbra.real-time.com (Postfix) with ESMTP id D960B5067B1
	for <linux-wireless@vger.kernel.org>; Wed,  7 May 2014 07:06:47 -0500 (CDT)
Received: from zimbra.real-time.com ([127.0.0.1])
	by localhost (zimbra.real-time.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WXTg6MLN2YJH for <linux-wireless@vger.kernel.org>;
	Wed,  7 May 2014 07:06:42 -0500 (CDT)
Received: from esk.lan (CPE-121-213-161-147.lns11.cht.bigpond.net.au [121.213.161.147])
	by zimbra.real-time.com (Postfix) with ESMTPSA id 992165067BB
	for <linux-wireless@vger.kernel.org>; Wed,  7 May 2014 07:06:42 -0500 (CDT)
Date: Wed, 7 May 2014 22:06:34 +1000
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org
Subject: mwifiex: no wr_port available
Message-ID: <20140507120634.GM17490@us.netrek.org> (sfid-20140507_140652_584801_F5D6A138)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G'day,

Is there a short duration leak of wr_port in
mwifiex_sdio_host_to_card()?

If mwifiex_host_to_card_mp_aggr fails because of is_suspended in
mwifiex_write_data_sync, is the wr_port ever released?

Or maybe mp_wr_bitmap is re-read from the card when a download
interrupt occurs, or if an upload interrupt occurs after a command is
sent.

-- 
James Cameron
http://quozl.linux.org.au/
