Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:51182 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab2EHHZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 03:25:06 -0400
Message-ID: <4FA8C9C8.2020906@01019freenet.de> (sfid-20120508_092511_435092_9EF8686C)
Date: Tue, 08 May 2012 09:22:48 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Jouni Malinen <j@w1.fi>, hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken aggregation
 handling?
References: <4FA75983.9040003@01019freenet.de>  <201205070702.q4772uem002960@mail.maya.org>  <4FA7A13D.6020405@01019freenet.de>  <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com>  <20120507135533.GA19222@w1.fi> <4FA8BD11.3080703@01019freenet.de> <1336458864.4328.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336458864.4328.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-05-08 at 08:28 +0200, Andreas Hartmann wrote:
> 
>> This means for rt2x00: to get 11w working with hw encryption enabled,
>> there needs to be some differentiation for the encryption of management
>> frames: if management frame, let mac80211 do the job - all other frames
>> should be encrypted by hw.
>> Correct?
> 
> That might not be sufficient -- you might have control over TX, but if
> the hardware attempts to decrypt encrypted mgmt frames you're out of
> luck entirely.

This means, that if hw encryption is enabled, the encryption must be
done entirely by hw (because of rx) and therefore, MFP must be supported
by hardware (does Ralink support MFP?)? Or is there a possibility to
tell the hardware not to decrypt some types of frames even if they are
encrypted?


Regards,
Andreas
