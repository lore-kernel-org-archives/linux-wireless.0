Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:56718 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbcGUPvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 11:51:35 -0400
Date: Thu, 21 Jul 2016 18:51:31 +0300
From: Jouni Malinen <j@w1.fi>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
Message-ID: <20160721155131.GA6292@w1.fi> (sfid-20160721_175138_925882_A3D73477)
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
 <1468248832-21969-6-git-send-email-akarwar@marvell.com>
 <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
 <33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 21, 2016 at 09:18:11AM +0000, Amitkumar Karwar wrote:
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Is it correct to ignore the key index? I see that brcmfmac ignores it as
> > well but I want to still confirm this.
> > 
> > Does this mean that with this patcfh mwifiex properly supports MFP?
> 
> Yes. We do pass MFP tests with this patch.

Did you test IGTK rekeying? This patch looks exactly as broken as it did
the last time it was proposed more than a year ago and after the same
concern not receiving any reaction.. hostapd will configure two
different IGTKs with different Key IDs and change the TX key on the AP
once all associated STAs have the new key. If the driver does not
support updating the TX key index, either the old or the new STAs
associated after rekeying will not have the correct key.

-- 
Jouni Malinen                                            PGP id EFC895FA
