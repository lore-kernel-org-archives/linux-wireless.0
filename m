Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49884 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbcGVP7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 11:59:53 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Jouni Malinen <j@w1.fi>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"Nishant Sarmukadam" <nishants@marvell.com>
Subject: RE: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Fri, 22 Jul 2016 15:59:47 +0000
Message-ID: <ab0bb1b790c74675a92b129916662545@SC-EXCH04.marvell.com> (sfid-20160722_175956_969357_CBA36F78)
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
 <1468248832-21969-6-git-send-email-akarwar@marvell.com>
 <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
 <33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com>
 <20160721155131.GA6292@w1.fi>
In-Reply-To: <20160721155131.GA6292@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> From: Jouni Malinen [mailto:j@w1.fi]
> Sent: Thursday, July 21, 2016 9:22 PM
> To: Amitkumar Karwar
> Cc: Kalle Valo; linux-wireless@vger.kernel.org; Cathy Luo; Nishant
> Sarmukadam
> Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
> 
> On Thu, Jul 21, 2016 at 09:18:11AM +0000, Amitkumar Karwar wrote:
> > > From: Kalle Valo [mailto:kvalo@codeaurora.org] Is it correct to
> > > ignore the key index? I see that brcmfmac ignores it as well but I
> > > want to still confirm this.
> > >
> > > Does this mean that with this patcfh mwifiex properly supports MFP?
> >
> > Yes. We do pass MFP tests with this patch.
> 
> Did you test IGTK rekeying? This patch looks exactly as broken as it did
> the last time it was proposed more than a year ago and after the same
> concern not receiving any reaction.. hostapd will configure two
> different IGTKs with different Key IDs and change the TX key on the AP
> once all associated STAs have the new key. If the driver does not
> support updating the TX key index, either the old or the new STAs
> associated after rekeying will not have the correct key.
> 

Thanks for your feedback and guidance on this.

I am trying to understand the problem you mentioned during IGTK rekeying. Today I ran tests with two stations connecting an AP. MFP is enabled on all of them.

On hostapd side, my observation is add_key() is always called followed by set_default_mgmt_key(). set_default_mgmt_key() sets the key added by add_key() as default key.

We are ignoring set_default_mgmt_key() and updating Tx key index during add_key() itself.

Your concerns is we should not update Tx key index during add_key(). Reason is IGTK rekeying is not yet completed with all stations. Right?

Regards,
Amitkumar
