Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:45146 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYKAVbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 17:31:09 -0400
Received: by yx-out-2324.google.com with SMTP id 8so765910yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 14:31:07 -0700 (PDT)
Message-ID: <43e72e890811011431j1f286d5ewf8985373e1312657@mail.gmail.com> (sfid-20081101_223117_232580_0EDB43D4)
Date: Sat, 1 Nov 2008 14:31:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Julien HENRY" <henryju@yahoo.fr>
Subject: Re: Re : Not associated with Intel 4965
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <170039.58975.qm@web28509.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <170039.58975.qm@web28509.mail.ukl.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 1, 2008 at 1:48 PM, Julien HENRY <henryju@yahoo.fr> wrote:
>> We no longer have iwl4965, the new name is iwlagn, try that.
>
> Not better (please note that I've upgraded to kernel 2.6.27.4-desktop-0.uc1mnb since my last post):
>
> # modprobe iwlagn
> WARNING: Error inserting iwlcore (/lib/modules/2.6.27.4-desktop-0.uc1mnb/updates/drivers/net/wireless/iwlwifi/iwlcore.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting iwlagn (/lib/modules/2.6.27.4-desktop-0.uc1mnb/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko.gz): Unknown symbol in module, or unknown parameter (see dmesg)

I see a discrepancy on the directory where the modules are being
picked up on. The ones that should be used are the ones in updates for
compat-wireless, your kernel drivers are under kernel. Lets try this
to be sure:

cd /lib/modules/2.6.27.4-desktop-0.uc1mnb/kernel/drivers/net/wireless/iwlwifi

rename everything there from foo to foo.ignore, for example, then run

sudo depmod -ae

and finally then try unloading all the wireless modules and then try
loading iwlagn.
