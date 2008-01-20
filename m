Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59311 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbYATTXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 14:23:19 -0500
Message-ID: <47939FA3.5040401@garzik.org> (sfid-20080120_192324_359186_211BB609)
Date: Sun, 20 Jan 2008 14:23:15 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Ian Brown <ianbrn@gmail.com>
CC: netdev@vger.kernel.org, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: net 2.6.25 is broken when building with wireless/iwlwifi
References: <d0383f90801200601y71472ae6ha638c1567d4abde4@mail.gmail.com>
In-Reply-To: <d0383f90801200601y71472ae6ha638c1567d4abde4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian Brown wrote:
> Hello,
> net 2.6.25 is broken when building with the wireless/iwlwifi
> subtree;  we get the following errors (we noticed that iwl_down() and
> iwl_resume()
> implementation do exist in garzik tree, but there are more differences
> so a simple
> patch with only adding these two methods might be risky)
> 
> ...
> ...
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function 'iwl3945_pci_remove':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:8639: error: implicit
> declaration of function 'iwl_down'
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function 'iwl3945_pci_resume':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:8779: error: implicit
> declaration of function 'iwl_resume'
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1
> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

hrm, that sounds like a potential mis-merge on my part (though 
ultimately linville should be re-syncing with net-2.6.25 soon anyway)

	Jeff


