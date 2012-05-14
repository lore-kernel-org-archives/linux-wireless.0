Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27331 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab2ENSb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 14:31:26 -0400
Date: Mon, 14 May 2012 11:31:24 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: enable enhanced bmiss detection
Message-ID: <20120514183124.GA4057@pista> (sfid-20120514_203130_769558_36071A45)
References: <1337017652-3962-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1337018219.29436.24.camel@joe2Laptop>
 <20120514180339.GA4030@pista>
 <4FB14A4D.1030002@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FB14A4D.1030002@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 09:09:17PM +0300, Kalle Valo wrote:
> On 05/14/2012 09:03 PM, Pedersen, Thomas wrote:
> > On Mon, May 14, 2012 at 10:56:59AM -0700, Joe Perches wrote:
> >
> >> Why 2 messages when 1 message might do?
> >>
> >> 	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
> >> 					       vif->fw_vif_idx, enable);
> >> 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> >> 		   "%s enhanced fw bmiss detection: %s\n",
> >> 		   enable ? "enable" : "disable",
> >> 		   err ? "OK" : "failed");
> > 
> > OK that seems nicer. Should we still print the error code, or maybe it
> > doesn't really matter?
> 
> I missed this in the original review, but it's actually better to not
> use ath6kl_dbg() for error messages. They are more difficult to notice
> that way.
> 
> Or did you have a specific reason for using ath6kl_dbg()?

No, you're right. However, if we consolidate these messages they will
both be under ath6kl_dbg() or ath6kl_err(), and neither one would be
correct.

How about just keeping these separate and printing the error through
ath6kl_err()?

Thomas
