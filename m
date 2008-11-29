Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:47674 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYK2MlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 07:41:22 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: [PATCHv2] zd1211rw: use unaligned safe memcmp() in-place of compare_ether_addr()
Date: Sat, 29 Nov 2008 12:40:50 +0000
References: <BAY104-DAV2759DEF86863A0B2E73A299040@phx.gbl>
In-Reply-To: <BAY104-DAV2759DEF86863A0B2E73A299040@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811291240.50958.hs4233@mail.mn-solutions.de> (sfid-20081129_134141_146914_B1F48F9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -        if (likely(!compare_ether_addr(tx_hdr->addr2,
> rx_hdr->addr1))) +        if (likely(!memcmp(tx_hdr->addr2,
> rx_hdr->addr1, ETH_ALEN))) {
>              __skb_unlink(skb, q);

Wouldn't it be better to fix compile_ether_addr instead?
