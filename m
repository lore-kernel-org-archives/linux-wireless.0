Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54087 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbcIIJLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:11:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv8,1/4] add basic register-field manipulation macros
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472644007-20959-2-git-send-email-jakub.kicinski@netronome.com>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Message-Id: <20160909091148.14A2361EA3@smtp.codeaurora.org> (sfid-20160909_111206_194244_8C2AD435)
Date: Fri,  9 Sep 2016 09:11:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> Common approach to accessing register fields is to define
> structures or sets of macros containing mask and shift pair.
> Operations on the register are then performed as follows:
> 
>  field = (reg >> shift) & mask;
> 
>  reg &= ~(mask << shift);
>  reg |= (field & mask) << shift;
> 
> Defining shift and mask separately is tedious.  Ivo van Doorn
> came up with an idea of computing them at compilation time
> based on a single shifted mask (later refined by Felix) which
> can be used like this:
> 
>  #define REG_FIELD 0x000ff000
> 
>  field = FIELD_GET(REG_FIELD, reg);
> 
>  reg &= ~REG_FIELD;
>  reg |= FIELD_PREP(REG_FIELD, field);
> 
> FIELD_{GET,PREP} macros take care of finding out what the
> appropriate shift is based on compilation time ffs operation.
> 
> GENMASK can be used to define registers (which is usually
> less error-prone and easier to match with datasheets).
> 
> This approach is the most convenient I've seen so to limit code
> multiplication let's move the macros to a global header file.
> Attempts to use static inlines instead of macros failed due
> to false positive triggering of BUILD_BUG_ON()s, especially with
> GCC < 6.0.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

3e9b3112ec74 add basic register-field manipulation macros
faad5433b722 mt7601u: remove redefinition of GENMASK
adcc710d0a9e mt7601u: remove unnecessary include
d43af50566b4 mt7601u: use linux/bitfield.h

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9306999/
