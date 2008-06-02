Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:61581 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYFBPBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:01:31 -0400
Received: by fk-out-0910.google.com with SMTP id 18so918296fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 08:01:29 -0700 (PDT)
Message-ID: <8704f27d0806020801g1785d067j9c28832a7e5c39e3@mail.gmail.com> (sfid-20080602_170135_023020_DD375EAE)
Date: Mon, 2 Jun 2008 18:01:29 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: Barteq <barteqpl@gmail.com>
Subject: Re: iwlwifi: Bug - can't connect to WPA PSK access point any more
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <op.ub3jirfui79708@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <op.ub3jirfui79708@thinkpad>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Some facts:
> kernel: Linux thinkpad 2.6.26-rc4-zen0 #1 SMP PREEMPT Wed May 28 03:00:38
> CEST 2008 i686 GNU/Linux
> iwl module: 1.2.26ks from 01.06.2008 compat-wireless pack
> ucode: iwlwifi-4965-ucode-4.44.1.20
>

can you please check that you have this one ?

1b7a0e7709ba92423894c612c4dca88bec315a75
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=1b7a0e7709ba92423894c612c4dca88bec315a75

> Maybe I'm donig something wrong, maybe it's not a bug, but.. it is extremly
> irritating.. I'cant use wifi at home, but it works in every other location!

Well, in the meantime, you can load the module with swcrypto=1, this
will make things work

> Even today was using wpa-psk network.. based on some newer wrt54gl linksys
> AP - without any serious issues.

This might be because your AP does group key rekeying. I just checked
with a 1250 Cisco AP, group key rekeying works (I configured the AP to
do rekeying every 15 seconds...) This might also be because the AP
implements the rekeying in a funny way (in terms of key indeces), that
iwlwifi doesn't know how to deal with (just thinking aloud).

Please send your wpa_supp conf file over.
Please try to disable the group key rekeying just to see what happens....

-- 
Emmanuel Grumbach
egrumbach@gmail.com
