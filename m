Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:52869 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZFAWBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 18:01:33 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 666FA77D3E3
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2009 00:01:30 +0200 (CEST)
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id F2EC28180C5
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2009 00:00:15 +0200 (CEST)
Received: from [192.168.1.189] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 0A768818103
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2009 00:00:12 +0200 (CEST)
Message-ID: <4A244F6C.3000509@free.fr>
Date: Tue, 02 Jun 2009 00:00:12 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: b43 : unaligned access on mips
References: <4A244E19.7090501@free.fr>
In-Reply-To: <4A244E19.7090501@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

matthieu castet wrote:
> Hi,
> 
> b43_generate_plcp_hdr generate unaligned access on mips with gcc [1] 
> from openwrt.
> 
> A small testcase [2] show that &plcp->data is access as a 32 bit aligned 
> variable (see the "lw      $2,0($4)" and "sw      $2,0($4)").
> I don't know enough mips to know if it is a gcc bug (ignoring the packed 
> attribute) or something missing in b43 code.
For example using "plcp->data" instead "*data" produce the correct code.
