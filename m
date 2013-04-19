Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37120 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967984Ab3DSLNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 07:13:34 -0400
Received: by mail-ie0-f178.google.com with SMTP id aq17so3011007iec.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 04:13:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL1gcdNQMRyiR+dyuPWYFCfokG9azoZugFQOqAZqt2x4UbKoLA@mail.gmail.com>
References: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
	<1366201848-18009-3-git-send-email-stf_xl@wp.pl>
	<CAL1gcdNQMRyiR+dyuPWYFCfokG9azoZugFQOqAZqt2x4UbKoLA@mail.gmail.com>
Date: Fri, 19 Apr 2013 13:13:34 +0200
Message-ID: <CAGXE3d-a00=4edmbpEgjkDEuax+bnkqJJ70osDhUMe__Jx_0=w@mail.gmail.com> (sfid-20130419_131341_865087_5B0AF999)
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2800: nulify all last words of TXWI
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan,

On Fri, Apr 19, 2013 at 11:49 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Wouldn't it be easier / better to simply clear the whole descriptor at
> the start, instead of selective clearing parts of it after everything
> has been written already?

This would add a number of unneeded writes to DMA coherent memory.
And since the descriptor is initialized word by word Stanislaw's approach
looks reasonable to me.

Helmut
