Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57430 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3G3V4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 17:56:10 -0400
Received: by mail-oa0-f41.google.com with SMTP id j6so8064619oag.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 14:56:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374827327-3464-16-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
	<1374827327-3464-16-git-send-email-johannes@sipsolutions.net>
Date: Wed, 31 Jul 2013 00:56:09 +0300
Message-ID: <CAB3XZEcZX8u5Fcsf7mbbso9O0krhLVgzdT9Ay8dxsv_T+_SOhQ@mail.gmail.com> (sfid-20130730_235614_240105_A4C634B9)
Subject: Re: [PATCH 15/30] iwlwifi: mvm: reprobe device on firmware error
 during restart
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 11:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If we get a firmware error during restart, we currently abandon any
> hope and simply fail, getting stuck until the driver is reloaded.
> Unfortunately, there isn't really much else we can do since restart
> will likely continue to fail, and asking mac80211 for disconnection
> just causes more error.
>
> To allow the user to at least set up the device again completely
> from scratch, reprobe the device and in doing so completely destroy
> any mac80211/driver state.
>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +               /*
> +                * get a module reference to avoid doing this while unloading
> +                * anyway and to avoid scheduling a work with code that's
> +                * being removed.
> +                */
> +               if (!try_module_get(THIS_MODULE)) {
> +                       IWL_ERR(mvm, "Module is being unloaded - abort\n");
> +                       return;
> +               }
> +
> +               reprobe = kzalloc(sizeof(*reprobe), GFP_ATOMIC);
> +               if (!reprobe)
> +                       return;

missing module_put() :)

Eliad.
