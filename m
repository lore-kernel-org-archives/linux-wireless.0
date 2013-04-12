Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:42885 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab3DLBrB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 21:47:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Troy Kisky <troy.kisky@boundarydevices.com>,
	Yogesh Powar <yogeshp@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Doug Anderson <dianders@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 11 Apr 2013 18:45:21 -0700
Subject: RE: [PATCH 2/2] mwifiex: remove redundant initialization for
 bss_descriptor
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96CDC@SC-VEXCH1.marvell.com> (sfid-20130412_034717_897752_F3B4F885)
References: <1365727993-20941-1-git-send-email-bzhao@marvell.com>
 <1365727993-20941-2-git-send-email-bzhao@marvell.com>
 <51675CFD.8030603@boundarydevices.com>
In-Reply-To: <51675CFD.8030603@boundarydevices.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Troy,

Thanks for reviewing.

> > -	priv->curr_bss_params.bss_descriptor.disable_11ac = true;
> > -
> 
> Should the = true line be moved below the memcpy?  Your way produces 
> the same behavior, but was it buggy before?

"bss_descriptor.disable_11ac = true" shouldn't be set after memcpy, because bss_desc->disable_11ac reflects the associated AP's 11ac setting here.

Perhaps we should set "bss_desc->disable_11ac = true" earlier before parsing AP's beacon IE?

@@ -184,6 +184,8 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
        else
                bss_desc->bss_mode = NL80211_IFTYPE_STATION;

+       bss_desc->disable_11ac = true;
+
        return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }

This flag can be reset to false if AP's beacon does advertise 11ac support.

Yogesh, any thoughts?

We had offline discussion on replacing disable_11ac with existing VHT flags.
Maybe initializing it in mwifiex_fill_new_bss_desc() is way to go?

Thanks,
Bing

> >   	/* Make a copy of current BSSID descriptor */
> >   	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
> >   	       sizeof(priv->curr_bss_params.bss_descriptor));

