Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2EHGe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 02:34:29 -0400
Message-ID: <1336458864.4328.3.camel@jlt3.sipsolutions.net> (sfid-20120508_083432_871955_CF239592)
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Jouni Malinen <j@w1.fi>, hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Date: Tue, 08 May 2012 08:34:24 +0200
In-Reply-To: <4FA8BD11.3080703@01019freenet.de>
References: <4FA75983.9040003@01019freenet.de>
	 <201205070702.q4772uem002960@mail.maya.org>
	 <4FA7A13D.6020405@01019freenet.de>
	 <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com>
	 <20120507135533.GA19222@w1.fi> <4FA8BD11.3080703@01019freenet.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-08 at 08:28 +0200, Andreas Hartmann wrote:

> This means for rt2x00: to get 11w working with hw encryption enabled,
> there needs to be some differentiation for the encryption of management
> frames: if management frame, let mac80211 do the job - all other frames
> should be encrypted by hw.
> Correct?

That might not be sufficient -- you might have control over TX, but if
the hardware attempts to decrypt encrypted mgmt frames you're out of
luck entirely.

johannes

