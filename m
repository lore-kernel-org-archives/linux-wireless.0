Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34178 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbbHQXQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 19:16:17 -0400
MIME-Version: 1.0
In-Reply-To: <55D238D4.20800@broadcom.com>
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
 <339fc87526f51233b262315b2297f68e3b00c7b6.1439838526.git.raphael.beamonte@gmail.com>
 <55D238D4.20800@broadcom.com>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Mon, 17 Aug 2015 19:15:57 -0400
Message-ID: <CAE_Gge1n9LGY=4EOzJsvKNWpKqz5E0hwysddn76VLWB6qqnLUw@mail.gmail.com> (sfid-20150818_011633_162352_18719762)
Subject: Re: [PATCHv2 5/5] staging: wilc1000: replace MALLOC_WILC_BUFFER()
 macro to avoid possible memory leak
To: Arend van Spriel <arend@broadcom.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-08-17 15:41 GMT-04:00 Arend van Spriel <arend@broadcom.com>:
> Probable MACRO_WILC_BUFFER should be MALLOC_WILC_BUFFER here.

Good catch!

> There is really no need to print an error message here. kmalloc will blurb
> enough info when it fails.

Ok!

> So these buffers are globals? So does this driver support multiple devices,
> ie. how are these used when two wilc1000 supported devices are present.

Not sure. I mostly did code refactoring to have a clearer source code
and try to respect the kernel code style. I don't have a compatible
device to try and test it unfortunately.

Thanks for the feedback. I just sent a revised version of the patch
taking your comments into account.
