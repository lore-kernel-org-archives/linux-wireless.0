Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1LULdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 06:33:42 -0500
Date: Wed, 21 Dec 2011 12:33:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 firmware errors: tentative debugging
Message-ID: <20111221113329.GA2235@redhat.com> (sfid-20111221_123345_809893_0B227103)
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
 <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
 <20111124125414.GA8077@redhat.com>
 <CAJZjf_zM2zBsoh66KcRwgi-jS7DF-qH5-sKrUoCB=hFTPES7LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
In-Reply-To: <CAJZjf_zM2zBsoh66KcRwgi-jS7DF-qH5-sKrUoCB=hFTPES7LA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pedro,

On Tue, Nov 29, 2011 at 05:07:55PM +0000, Pedro Francisco wrote:
> My country has the following regulatory.bin lines:
> 
> country PT:	(2402.000 - 2482.000 @ 40.000), (N/A, 20.00)	(5170.000 -
> 5250.000 @ 40.000), (N/A, 20.00)	(5250.000 - 5330.000 @ 40.000), (N/A,
> 20.00), DFS <------ removed whole line	(5490.000 - 5710.000 @ 40.000),
> (N/A, 27.00), DFS <------ removed whole line
> 
> If I remove the last two lines, everything works as expected, i.e., NO
> "Microsode SW error". If I include any of the last two, the Microcode
> will issue an error.
> 
> I've tried every combination of those lines except just one of
> "(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS" OR "(5490.000 -
> 5710.000 @ 40.000), (N/A, 27.00), DFS".

Attached patch stop to trigger error on my setup with "iw dev wlan0 scan
passive". Can you check if it also fix problem on your normal wireless
workload?

Thanks
Stanislaw

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwlegacy-do-not-promote-to-active-scan-on-transmistion-detect.patch"

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index daef6b5..b6df518 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2624,12 +2624,12 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	}
 
 	/*
-	 * If active scaning is requested but a certain channel
-	 * is marked passive, we can do active scanning if we
-	 * detect transmissions.
+	 * If active scaning is requested but a certain channel is marked
+	 * passive, we can do active scanning if we detect transmissions. For
+	 * passive only scanning disable switching to active on any channel.
 	 */
 	scan->good_CRC_th =
-	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_DISABLED;
+	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_NEVER;
 
 	len =
 	    il_fill_probe_req(il, (struct ieee80211_mgmt *)scan->data,

--7AUc2qLy4jB3hD7Z--
