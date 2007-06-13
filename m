Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tartu.cyber.ee ([193.40.6.68]:2735 "EHLO tartu.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXFMJkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 05:40:19 -0400
From: Meelis Roos <mroos@linux.ee>
To: hs4233@mail.mn-solutions.de, linux-wireless@vger.kernel.org
Subject: Re: libertas warnings in upstream
In-Reply-To: <200706130953.57827.hs4233@mail.mn-solutions.de>
Message-Id: <20070613092651.6B37414115@rhn.tartu-labor>
Date: Wed, 13 Jun 2007 12:26:51 +0300 (EEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HS> Fancy trying this tree with your current kernel?
HS> 
HS>    git clone --reference /usr/src/linux-git git://git.infradead.org/libertas-2.6
HS>    make -C /usr/src/linux-git modules SUBDIRS=libertas-2.6/drivers/net/wireless/libertas

These are still present on sparc64, gcc 4.1.2:

  CC [M]  /home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/cmd.o
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/cmd.c: In function 'wlan_cmd_802_11_set_wep':
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/cmd.c:189: warning: large integer implicitly truncated to unsigned type
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/cmd.c:195: warning: large integer implicitly truncated to unsigned type

  CC [M]  /home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/debugfs.o
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/debugfs.c: In function 'libertas_getscantable':
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/debugfs.c:85: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
/home/mroos/compile/libertas-2.6/drivers/net/wireless/libertas/debugfs.c:85: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type 'u64'

%08zx or something similar here?

-- 
Meelis Roos
