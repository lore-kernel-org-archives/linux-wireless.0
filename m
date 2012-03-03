Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2CCQNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 11:13:40 -0500
Date: Sat, 3 Mar 2012 16:15:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat: makes all compat symbols EXPORT_SYMBOL_GPL()
Message-ID: <20120303161537.0b4ac739@pyramind.ukuu.org.uk> (sfid-20120303_171354_984404_7D005767)
In-Reply-To: <4F52141C.2050808@broadcom.com>
References: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
	<4F52141C.2050808@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Some of the modules in this patch are dual-licensed. I was under the 
> impression that EXPORT_SYMBOL_GPL was specifically for GPL-only code 
> although I could not find any specifics in the Documentation folder. Do 
> you (or someone else) have a reference on this topic?

If your code is licensed GPL or greater rights then you shouldn't have a
problem. The module loader recognizes

	"GPL"
	"GPL v2"
	"GPL and additional rights"
	"Dual BSD/GPL"
	"Dual MIT/GPL"
	"DUal MPL/GPL"

as legitimate users of _GPL. Any work which is derivative of the kernel
(which in practise I suspect means almost any module) will need a GPL
compatible licence anyway.

