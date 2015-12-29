Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:39758 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752813AbbL2Ab1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 19:31:27 -0500
Message-ID: <1451349084.3219.19.camel@perches.com> (sfid-20151229_013145_361962_C8214683)
Subject: Re: [PATCH] /drivers/net/wireless/ath/ath9k remove unnecessary ?:
 operator
From: Joe Perches <joe@perches.com>
To: Ivan Safonov <insafonov@gmail.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 28 Dec 2015 16:31:24 -0800
In-Reply-To: <5681818A.9060406@gmail.com>
References: <20151228134852.GA10572@alpha.sfu-kras.ru>
	 <1451325412.3219.12.camel@perches.com> <5681818A.9060406@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-29 at 01:38 +0700, Ivan Safonov wrote:
> On 12/29/2015 12:56 AM, Joe Perches wrote:
> > On Mon, 2015-12-28 at 20:48 +0700, Ivan Safonov wrote:
> > > ((thermometer < 0) ? 0 : (thermometer == X)) and (thermometer ==
> > > X) are equal for X >= 0.
> > X is not guaranteed to be >= 0 here
> 
> X is fixed constant. In this case X is {0, 1, 2}.

Looks like it can be -1 to me (range: -1, 0, 1, 2)

static int ar9003_hw_get_thermometer(struct ath_hw *ah)
{
	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
	struct ar9300_base_eep_hdr *pBase = &eep->baseEepHeader;
	int thermometer =  (pBase->miscConfiguration >> 1) & 0x3;

	return --thermometer;
}

