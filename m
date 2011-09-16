Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37419 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1IPJmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 05:42:43 -0400
Received: by gxk6 with SMTP id 6so2127291gxk.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 02:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316100982-1815-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316100982-1815-1-git-send-email-wey-yi.w.guy@intel.com>
Date: Fri, 16 Sep 2011 11:42:42 +0200
Message-ID: <CAGXE3d8rVyF9VTtjDtatvX9e6dKLAGtYNEq5wEfvNGLtu_U9UQ@mail.gmail.com> (sfid-20110916_114247_284504_C5223F3E)
Subject: Re: [PATCH 3.1] iwlagn: workaround bug crashing some APs
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Don Fry <donald.h.fry@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 15, 2011 at 5:36 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> From: Don Fry <donald.h.fry@intel.com>
>
> This patch reverts commit 9b7688328422b88a7a15dc0dc123ad9ab1a6e22d which
> was introduced in 2.6.38-rc1.  It works around a problem where the iwlagn
> driver stimulates a bug crashing (requiring power cycle to recover) some
> APs under heavy traffic.

[...]

> +       /*
> +        * Including the following line will crash some AP's.  This
> +        * workaround removes the stimulus which causes the crash until
> +        * the AP software can be fixed.
>        hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
> +        */

Would be interesting to know which AP models suffer from this issue since
other drivers might also be affected if max_tx_aggregation_subframes is set
to something != 64 or 0.

Did this appear with the previous LINK_QUAL_AGG_FRAME_LIMIT_DEF
value of 31 too?

If we can crash APs by sending values != 64 or 0 it might even make sense
to not allow drivers to overwrite the max AMPDU size ...

Helmut
