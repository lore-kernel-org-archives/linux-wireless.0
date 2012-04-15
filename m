Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33937 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab2DOKbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:31:47 -0400
Message-ID: <4F8AA38E.1040702@openwrt.org> (sfid-20120415_123150_561635_4ACC050D)
Date: Sun, 15 Apr 2012 12:31:42 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 1/3] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-14 10:01 PM, Gabor Juhos wrote:
> The REDUCE_SCALED_POWER_BY_THREE_CHAIN symbol is
> defined in different eeprom files, and the value
> varies between the different files.
> 
> In eeprom_def.c and in ar9003_eeprom.c the value
> of the symbol is 9, however the comments in these
> files indicates the value should be 10*log10(3)*2
> which is 9.54242509439325. Replace the the value
> to 10 in these files.
> 
> Also add comments to eeprom_9287.c.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
I think we should keep the value 9.
If I understand the logic behind the power increase through chain
combining properly, this value only describes the worst-case (wrt.
regulatory compliance) upper limit of tx power, whereas in practice the
measured combined power output will be much lower than that due to
signal/phase differences.
Regulatory compliance is already properly tested on all devices with the
truncated value 9, so I don't think that we need to be even more
conservative and round up here.

- Felix
