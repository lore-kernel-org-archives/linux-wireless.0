Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2EISYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 14:24:39 -0400
Received: by dady13 with SMTP id y13so628597dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 11:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
Date: Wed, 9 May 2012 20:24:38 +0200
Message-ID: <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com> (sfid-20120509_202443_360152_9162C333)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

> What are the sdd files for and why would they be different?
>
SDD files contains some kind of radio calibration data and Bluetooth
arbitrage tables.
They must be aligned with particular RF design and presence of Bluetooth PTA.
If you are using PTA is your design, you should have SDD with PTA tables in.

> I noticed the driver parses some information directly from the sdd
> file in the cw1200_parse_SDD_file function.  Does the file get used
> for anything else?
>
It is downloaded to firmware and the firmware uses data from it.

> If a PTA element is found the code always sets priv->is_BT_Present =
> true.  If I do not have Blue Tooth in my system should this still be
> set?
>
Yes if you share antenna and use PTA (Bluetooth arbitrage) in your design.
But in this case you should have SDD with PTA entry in.

Dmitry
