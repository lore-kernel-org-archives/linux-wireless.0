Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61080 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3AYImc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:42:32 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so100121wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 00:42:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1731354.xZITKB59tC@sylvesterjr.pats.ua.ac.be>
References: <1731354.xZITKB59tC@sylvesterjr.pats.ua.ac.be>
Date: Fri, 25 Jan 2013 09:42:31 +0100
Message-ID: <CAGXE3d_fD9etSnMKFUb6YGz=4g85ACkvdgyPjusMJXus-nvFYg@mail.gmail.com> (sfid-20130125_094235_747379_59BFB652)
Subject: Re: Unable to get RTS/CTS working in rt2800
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 4:58 PM, Erwin Van de Velde
<erwin.vandevelde@gmail.com> wrote:
> In a test setup with 802.11a/n a colleague and I tried enabling RTS/CTS. The
> only thing we got however was a CTS to self. RTS threshold was 1000B,
> packet size 1400B.

Did you use 11n aggregation?

> We looked for other options but did not find anything
> helpful, what else can we try to enable RTS/CTS?

Yup, there are several issues there:
- The hw ignores RTS thresholds for AMPDUs AFAIK
- HT protection always uses CTS-to-self (hardcoded in driver in
rt2800_config_ht_opmode)

I don't think any other driver allows to configure if RTS-CTS or
CTS-to-self should be used?
You can easily enforce RTS-CTS for 11n transmissions by changing
rt2800_config_ht_opmode.

HTH,
Helmut
