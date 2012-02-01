Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49509 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2BAK1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 05:27:54 -0500
Received: by pbdu11 with SMTP id u11so964655pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 02:27:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
Date: Wed, 1 Feb 2012 11:27:53 +0100
Message-ID: <CAGXE3d-tkefeDODh8m5G-rEBTLF7ExrVZbgT=RJPxnMvGcBciw@mail.gmail.com> (sfid-20120201_112758_007051_AD6EA996)
Subject: Re: [PATCH 1/4] rt2800: radio 3xxx: reprogram only lower bits of RF_R3
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 4:17 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> -       rt2800_rfcsr_write(rt2x00dev, 3, rf->rf3);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR3_K, rf->rf3);
> +       rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);

Mind to add the same/similar comment here as the legacy driver does?
It seems as if this only applies to RT3370 and newer while the change
doesn't affect older chipsets:

RT3370/RT3390 RF version is 0x3320 RF_R3 [7:4] is not reserved bits
RF_R3[6:4] (pa1_bc_cck) : PA1 Bias CCK
RF_R3[7] (pa2_cc_cck) : PA2 Cascode Bias CCK

Thanks,
Helmut
