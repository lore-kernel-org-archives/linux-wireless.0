Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40005 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBSAPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:15:07 -0500
Received: by mail-pb0-f47.google.com with SMTP id rp16so17534280pbb.20
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:15:07 -0800 (PST)
Date: Tue, 18 Feb 2014 16:15:01 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor
 channels
Message-ID: <20140219001458.GF14296@garbanzo.do-not-panic.com> (sfid-20140219_011512_791316_51C501CA)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390818118-27261-7-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 12:21:58PM +0200, Ilan Peer wrote:
> Allow active scanning and frame injection on channels marked with
> IEEE80211_CHAN_NO_IR iff the channel is also marked with
> IEEE80211_CHAN_INDOOR_ONLY and the wireless core thinks that it
> operates in an indoor environment.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

I don't see why being indoor should allow to override the NO-IR
flag. I do see however why being indoor should enable to IR if
you are IR if you have the indoor flag. Enabling to IR if you are
indoor for all NO-IR channels is... pretty permissive I do not
see the correlation.

  Luis
