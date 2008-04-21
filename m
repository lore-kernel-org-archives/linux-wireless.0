Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:46580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYDUVv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 17:51:28 -0400
Received: by wa-out-1112.google.com with SMTP id m16so3405028waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 14:51:28 -0700 (PDT)
Message-ID: <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com> (sfid-20080421_235219_582037_563784BD)
Date: Tue, 22 Apr 2008 00:51:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "SL Baur" <steve@xemacs.org>
Subject: Re: [PATCH] iwlwifi 3945 debug parameter should be writable via sysfs
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 21, 2008 at 10:10 AM, SL Baur <steve@xemacs.org> wrote:
> Is there any reason why the debug parameter in the iwlwifi driver
>  should be read-only?
>
>  (Patch inlined and attached since I'm sure it will get whitespace
>  broken).
>
>
>  The debug parameter of the Intel 3945ABG driver should be writable
>  via sysfs.
>
>  Signed-off-by: SL Baur <steve@xemacs.org>
>  ---
>  This patch is against Linus' 2.6.25 release.
>
>  --- linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c~      2008-04-17
>  10:15:33.000000000 -0700
>  +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c       2008-04-20
>  23:49:35.000000000 -0700
>  @@ -8855,7 +8855,7 @@ MODULE_PARM_DESC(disable, "manually disa
>   module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
>   MODULE_PARM_DESC(hwcrypto,
>                  "using hardware crypto engine (default 0 [software])\n");
>  -module_param_named(debug, iwl3945_param_debug, int, 0444);
>  +module_param_named(debug, iwl3945_param_debug, int, 0644);
>   MODULE_PARM_DESC(debug, "debug output mask");
>   module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
>   MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
>
>  -sb
>
it doesn't have any affect on debug output though.  This variable is
copied to to another one in pci proble
so unless you have 2 cards there is no use for it.
Run time debug output can be handled through debug_level sysfs entry
/sys/bus/pci/drivers/iwl4965/debug_level
Yet this will be changed as well to be per device instead of per driver
Tomas
