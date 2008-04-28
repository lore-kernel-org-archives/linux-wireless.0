Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:1920 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYD1D6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 23:58:42 -0400
Received: by an-out-0708.google.com with SMTP id d31so1176198and.103
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 20:58:41 -0700 (PDT)
Message-ID: <43e72e890804272058v4158ce42x9a58684865d85398@mail.gmail.com> (sfid-20080428_055900_809340_6FEC5CE5)
Date: Sun, 27 Apr 2008 20:58:41 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Charles Figura" <charles.figura@wartburg.edu>
Subject: Re: [Fwd: Re: Problems loading from compat-wireless-2008-04-24]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48152DDB.9050702@wartburg.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48148E6F.3080703@wartburg.edu>
	 <43e72e890804271418ted6360bm88f1b1f29aec6790@mail.gmail.com>
	 <48152DDB.9050702@wartburg.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2008 at 6:52 PM, Charles Figura
<charles.figura@wartburg.edu> wrote:
> Okay, so I think I have an idea what might be going on.  I've attached
>  the modprobe -l for the various modules involved both after installation
>  and after uninstallation.  I note that after uninstallation, there are
>  still a few modules from the /lib/modules/2.6.24-16-generic/updates
>  folder.  Is this possibly due to an older self-installed compat-wireless
>  update?
>  Has monkeying around with non-apt packages goofed me up here?
>  If so, how can I fix it?

Maybe.

> figura@nightfall:~/compat-wireless-2008-04-27$ sudo modprobe -l iwl4965
>
> /lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/iwlwifi/compatible/iwl4965.ko
>  figura@nightfall:~/compat-wireless-2008-04-27$ sudo modprobe -l mac80211
>  /lib/modules/2.6.24-16-generic/updates/net/mac80211/mac80211.ko
>  figura@nightfall:~/compat-wireless-2008-04-27$ sudo modprobe -l
> iwlwifi_mac80211/lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/mac80211/compatible/net/mac80211/iwlwifi_mac80211.ko
>  figura@nightfall:~/compat-wireless-2008-04-27$
>
> figura@nightfall:/lib/modules/2.6.24-16-generic$ sudo modprobe -l
> iwlwifi_mac80211
>
> /lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/mac80211/compatible/net/mac80211/iwlwifi_mac80211.ko
>  figura@nightfall:/lib/modules/2.6.24-16-generic$ sudo modprobe -l mac80211
>  /lib/modules/2.6.24-16-generic/kernel/net/mac80211/mac80211.ko
>  figura@nightfall:/lib/modules/2.6.24-16-generic$ sudo modprobe -l iwl4965
>
> /lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/iwlwifi/compatible/iwl4965.ko
>  figura@nightfall:/lib/modules/2.6.24-16-generic$ sudo modprobe -l iwl3945
>
> /lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/iwlwifi/compatible/iwl3945.ko
>  figura@nightfall:/lib/modules/2.6.24-16-generic$

Do this:

dpkg -S  /lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/

keep note of that package and remote it, or just do

sudo make unload
sudo make uninstall
sudo rm -rf  /lib/modules/2.6.24-16-generic/updates/wireless/
sudo depmod -ae
sudo make install
sudo make unlaod
lsmod | grep iwl
# remove iwl mac80211 or any other stuff which make unload would not
have picked up on
# like modules from other packages
sudo modprobe iwl4965

Now you should be good.

  Luis
