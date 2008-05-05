Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:40850 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYEEQEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 12:04:32 -0400
Received: by fk-out-0910.google.com with SMTP id 18so733382fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 09:04:30 -0700 (PDT)
Message-ID: <8704f27d0805050904j41ddb0a9obbe2fdf231c4a625@mail.gmail.com> (sfid-20080505_180352_646769_F2E6D706)
Date: Mon, 5 May 2008 19:04:30 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1208969544.3312.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  I thought the DHCP broadcast ought to be encrypted with the broadcast
>  key (=keyidx 2)?? But its encrypted with the unicast key (keyidx 3). Or
>  am I really confused here? Please let me know if you have any ideas to
>  fix this!
>

Nope, a station never encrypts with broadcast key, it always encrypts
to the AP: RA = MAC of the AP, and TA = broadcast MAC.
So the key used for encryption of broadcast packet should be the
unicast key. The broadcast key is useful for RX only.

-- 
Emmanuel Grumbach
egrumbach@gmail.com
