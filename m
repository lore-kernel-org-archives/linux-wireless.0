Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64940 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0AZTAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 14:00:20 -0500
Received: by pwi21 with SMTP id 21so3165972pwi.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 11:00:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1NZoGF-0008Cr-CL@sipsolutions.net>
References: <E1NZoGF-0008Cr-CL@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Jan 2010 10:59:04 -0800
Message-ID: <43e72e891001261059t7a9d8fcdn1bdc7691d3e9d7be@mail.gmail.com>
Subject: Re: [ANN] crda: v1.1.1
To: linux-wireless@vger.kernel.org
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	Kel Modderman <kel@otaku42.de>,
	Kel Modderman <kelmo@kanotixguide.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 8:27 AM,  <wireless@sipsolutions.net> wrote:
>
> A new release of crda (v1.1.1) is available at:
>
> http://wireless.kernel.org/download/crda/crda-1.1.1.tar.bz2
>
> SHA1 sum: 73643b3f49b34c4150df4abb793a36792cc68fb7
>
> Here is the short log of the changes included in this
> release:
>
> Luis R. Rodriguez (1):
>      Space fix
>
> Paul Fertser (1):
>      Implement runtime loading of RSA public keys

Thanks to Paul Ferster for this patch. Its worth elaborating a little
more on this.

Typically CRDA has only allowed adding of public keys at build time.
Adding alternative public keys for CRDA allows for third party
authored files to be redistributed and used. This is now documented
here:

http://wireless.kernel.org/en/developers/Regulatory#Custom_regulatory_information

With the new patch by Paul you can read keys put in place on a
preconfigured directory, by default /etc/wireless-regdb/pubkeys. This
is currently only available with USE_OPENSSL=1 as gcrypt lacks a PEM
parser.

> Pavel Roskin (1):
>      CRDA and cross-compilation
>
> Tim Gardner (1):
>      crda: Cosmetic fix for udev path
>

  Luis
