Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52312 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0DGHF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 03:05:26 -0400
Received: by pva18 with SMTP id 18so471873pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 00:05:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100407053333.23713.61655.stgit@mj.roinet.com>
References: <20100407053333.23713.61655.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 7 Apr 2010 00:05:06 -0700
Message-ID: <q2k43e72e891004070005q14e8fb0ev5cb06f40d241242b@mail.gmail.com>
Subject: Re: [PATCH] ath9k: simplify AR9220 fixup code for AR_AN_TOP2 register
To: Pavel Roskin <proski@gnu.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 6, 2010 at 10:33 PM, Pavel Roskin <proski@gnu.org> wrote:
> Don't modify ah->iniModes, it's supposed to be constant.  Instead, apply
> the fixup when the data is written to the registers.
>
> Change ath9k_hw_init_eeprom_fix() to only determine whether the fixup is
> needed.
>
> This allows similteneous support for AR9220 cards that need AR_AN_TOP2
> fixup (such as Ubiquiti SR71-12) and those that don't need it (D-Link
> DWA-552 rev A2).
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Wow thank you for making sense and cleaning up this nasty POS code.

  Luis
