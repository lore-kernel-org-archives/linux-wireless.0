Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:45585 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3JGW5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 18:57:18 -0400
Received: by mail-la0-f41.google.com with SMTP id ec20so6164359lab.14
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 15:57:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42bj6Q-O0=+3TK1kwgfct6tN6hf+wRJa_nk3WfCTskQitg@mail.gmail.com>
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
 <20131004234514.GA11128@garbanzo.do-not-panic.com> <CAFSJ42YRmwZ-mK5yADsf=sfi7b5rEK9hFdH-waoswrubvyZddA@mail.gmail.com>
 <CAB=NE6UToY0zeuarb7f_aExCuxqmghCcmdRkxMSWR-CgGjRk6Q@mail.gmail.com> <CAFSJ42bj6Q-O0=+3TK1kwgfct6tN6hf+wRJa_nk3WfCTskQitg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 7 Oct 2013 15:56:56 -0700
Message-ID: <CAB=NE6Xs=ebxpQapB4xXu7edWfMEkgZu8hTyO98zfam56og2Hg@mail.gmail.com> (sfid-20131008_005721_344914_68926AB9)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	wcn36xx <wcn36xx@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 7, 2013 at 1:59 PM, Eugene Krasnikov <k.eugene.e@gmail.com> wrote:
> Hi Luis,
>
> I looked at your patch deeper and couple of questions appeared:
>
> 1) The first line in the function ath_regd_init will execute
> container_of with "struct ath_common". Do not you think we can try to
> access wrong memory area?

Good catch, can you add an ath_common to the general wcn data
structure and then embed the reg under it? That'd fix that.

> 2) __ath_regd_init will try to access EEPROM or at least call
> functions with eeprom related.

That's inherited from the language used on the HAL code. The HAL is no
longer a HAL and we have general "hardware code". The code in that
file is more than anything now just database specific information, as
such routines like ath_regd_get_eepromRD() could be renamed to reflect
they are simply accessing regulatory information from the card.

> It's a bit misleading because
> wcn36xx is not using eeprom. If possible could you please explain what
> is the connection between ath regd implementation and EEPROM?

Indeed, agreed. The way to properly use regulatory on the wcn driver
will be parse the nvram and populate the struct ath_regulatory
appropriately. This then makes the EEPROM verbiage inappropriate and
do welcome such changes reflected on regd.c but don't see them
required for wcn to use them. This can be made as further
clarifications once the wcn driver gets merged.

  Luis
