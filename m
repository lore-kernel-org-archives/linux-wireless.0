Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:57293 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S966323AbdIYUxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 16:53:32 -0400
Subject: Re: [PATCH] ath10k: add new cipher suite support
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org,
        Jouni Malinen <jouni@qca.qualcomm.com>
References: <1506115070-10467-1-git-send-email-rmanohar@qti.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <bff1aa84-d199-7b10-3718-33323a984954@dd-wrt.com> (sfid-20170925_225515_991671_233AFDBD)
Date: Mon, 25 Sep 2017 22:53:22 +0200
MIME-Version: 1.0
In-Reply-To: <1506115070-10467-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.09.2017 um 23:17 schrieb Rajkumar Manoharan:
> -	ar->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
> +
> +	/* QCA988x and QCA6174 family chips do not support CCMP-256, GCMP-128
> +	 * and GCMP-256 ciphers in hardware.
> +	 */
> +	if (!ar->hw_params.n_cipher_suites)
> +		ar->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
this is a bug. you do not set ar->hw->wiphy->n_cipher_suites if its non 
zero. this breaks ath10k crypto support for all chipsets except for QCA998X


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
