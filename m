Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49848 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343Ab0FZQM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 12:12:26 -0400
Date: Sat, 26 Jun 2010 08:08:00 -0700
From: Jouni Malinen <j@w1.fi>
To: Iuri Diniz <iuridiniz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Fwd: mesh configuration information element is wrong?
Message-ID: <20100626150800.GA20900@jm.kir.nu>
References: <AANLkTinHfFVr45OV3V6CT9auK3L-JfrCYUMQpeo9toTw@mail.gmail.com>
 <AANLkTimeR5kQX2hSNw0Ud0QOF0-nsqCFMkSNul9wwa7C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTimeR5kQX2hSNw0Ud0QOF0-nsqCFMkSNul9wwa7C@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 25, 2010 at 02:43:31PM -0300, Iuri Diniz wrote:

> I'm analyzing the 802.11s code and I think I've found that mesh
> configuration information element has wrongs sizes.
> 
> It is not according to my copy of 802.11s draft 3.

Draft 3 is quite old..

> on linux-wireless-testing/linux/include/ieee80211.h we have:
>  * struct ieee80211_meshconf_ie
>  * This structure refers to "Mesh Configuration information element"

> struct ieee80211_meshconf_ie {
>     u8 meshconf_psel;
>     u8 meshconf_pmetric;
>     u8 meshconf_congest;
>     u8 meshconf_synch;
>     u8 meshconf_auth;
>     u8 meshconf_form;
>     u8 meshconf_cap;
> } __attribute__ ((packed));

That matches otherwise with the latest draft (P802.11s/D6.0), but it
lacks one field. There is a 1-octet field "Mesh Peering Protocol
Identifier" between the _auth and _form fields in the latest draft.

-- 
Jouni Malinen                                            PGP id EFC895FA
