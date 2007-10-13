Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:8731 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbXJMJid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 05:38:33 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1183055mue
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 02:38:32 -0700 (PDT)
Message-ID: <47109214.3030409@gmail.com> (sfid-20071013_103838_176649_41301834)
Date: Sat, 13 Oct 2007 11:38:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer
 G for AR5212
References: <20071012150438.GC9407@pogo> <20071012150543.GD9407@pogo>	 <20071012150709.GE9407@pogo> <20071012150745.GF9407@pogo>	 <4af2d03a0710121433r1f32aaabt4bb8d50c61ef12d5@mail.gmail.com>	 <20071012223757.GA4994@pogo>	 <40f31dec0710130221o4b38d5fcld4239b48d24e8206@mail.gmail.com> <40f31dec0710130230xa5d4869x814ccdfad10802be@mail.gmail.com>
In-Reply-To: <40f31dec0710130230xa5d4869x814ccdfad10802be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2007 11:30 AM, Nick Kossifidis wrote:
> I mean something like this...
> 
> if(test_bit(MODE_IEEE80211B,hal->ah_capabilities.cap_mode)) {

this reminds me I wanted to get rid of locked set_bit and use __set_bit instead ;-).

> REGISTER_MODE(MODE_IEEE80211B);
> }

or do it directly in register_mode. I'm for making function from the macro in
that case.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
