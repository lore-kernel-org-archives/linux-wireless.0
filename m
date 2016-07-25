Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16929 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752931AbcGYJdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 05:33:25 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Jouni Malinen <j@w1.fi>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"Nishant Sarmukadam" <nishants@marvell.com>
Subject: RE: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Mon, 25 Jul 2016 09:33:22 +0000
Message-ID: <8edc3a8df13944cd8dbb6eb45362f96a@SC-EXCH04.marvell.com> (sfid-20160725_113353_766347_52EC01B1)
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
 <1468248832-21969-6-git-send-email-akarwar@marvell.com>
 <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
 <33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com>
 <20160721155131.GA6292@w1.fi>
 <ab0bb1b790c74675a92b129916662545@SC-EXCH04.marvell.com>
 <20160722165517.GA14456@w1.fi>
In-Reply-To: <20160722165517.GA14456@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> From: Jouni Malinen [mailto:j@w1.fi]
> Sent: Friday, July 22, 2016 10:25 PM
> To: Amitkumar Karwar
> Cc: Kalle Valo; linux-wireless@vger.kernel.org; Cathy Luo; Nishant
> Sarmukadam
> Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
> 
> On Fri, Jul 22, 2016 at 03:59:47PM +0000, Amitkumar Karwar wrote:
> > I am trying to understand the problem you mentioned during IGTK
> rekeying. Today I ran tests with two stations connecting an AP. MFP is
> enabled on all of them.
> >
> > On hostapd side, my observation is add_key() is always called followed
> by set_default_mgmt_key(). set_default_mgmt_key() sets the key added by
> add_key() as default key.
> >
> > We are ignoring set_default_mgmt_key() and updating Tx key index
> during add_key() itself.
> >
> > Your concerns is we should not update Tx key index during add_key().
> Reason is IGTK rekeying is not yet completed with all stations. Right?
> 
> Correct. set_default_mgmt_key() does not have much effect for the very
> first IGTK configuration, but whenever doing IGTK rekeying, hostapd
> behaves just like it does with GTK rekeying. In other words, a different
> Key ID is selected (alternating between 4 and 5), a random new IGTK is
> generated, the new IGTK is configured to the local driver (but the old
> IGTK is still supposed to be used for TX), each associated STA is
> notified of the new IGTK, the new IGTK is taken into use once the group
> key handshake has completed with each associated STA. It is that last
> operation that needs set_default_mgmt_key() to allow this rekeying to
> work correctly. If you update the TX Key ID on add_key(), you'll risk
> sending out frames that some of the associated STAs do not yet have a
> key to validate.
> 

Got it. We will implement set_default_mgmt_key() and check if any firmware changes required.

Regards,
Amitkumar
