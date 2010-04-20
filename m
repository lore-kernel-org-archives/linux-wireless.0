Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:58781
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753346Ab0DTIiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 04:38:10 -0400
Date: Tue, 20 Apr 2010 10:38:08 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: Johan Hovold <johan.hovold@lundinova.se>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] ath9k: fix corrupt frames being forwarded to
 mac80211
Message-ID: <20100420083808.GD5288@lundinova.se>
References: <20100420082519.GB5288@lundinova.se>
 <1271752088-13639-1-git-send-email-johan.hovold@lundinova.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271752088-13639-1-git-send-email-johan.hovold@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 20, 2010 at 10:28:07AM +0200, Johan Hovold wrote:
> Verify frame status by making sure that no error flags are set if frame
> is marked ok and that reserved bits 19 through 28 (0x1ff80000) are all
> zero, otherwise discarded frame (as ATH9K_PHYERR_HT_CRC_ERROR).

I used ATH9K_PHYERR_HT_CRC_ERROR for now, but perhaps there is better
choice?

