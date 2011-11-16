Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42490 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1KPKqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:46:48 -0500
Received: by ywt32 with SMTP id 32so4603563ywt.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 02:46:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116100915.GA2191@redhat.com>
References: <20111116100915.GA2191@redhat.com>
Date: Wed, 16 Nov 2011 11:46:48 +0100
Message-ID: <CAGXE3d8oPL9POJEZdb4urFVQXjPY2W8HYePLc2F804=W7nCfSw@mail.gmail.com> (sfid-20111116_114652_697565_B35C2F42)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:09 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> +       /*
> +        * Some devices can generate interrupts with empty CSR register, we
> +        * "handle" such irq's to prevent interrupt controller treat them as
> +        * spurious interrupts and disable irq line.
> +        */
>        if (!reg)
> -               return IRQ_NONE;
> +               return IRQ_HANDLED;

What if this interrupt belongs to a different device on a shared interrupt line?
In case reg is zero we can't be sure our device generated this interrupt, right?

Helmut
