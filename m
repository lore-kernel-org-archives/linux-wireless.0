Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19254 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732640AbeITUpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 16:45:03 -0400
Message-ID: <c95de2e727357c8f24330ee35fab9e7036b2aab4.camel@intel.com> (sfid-20180920_170113_964064_08178233)
Subject: Re: acpi/iwlwifi: thermal thermal_zone3: failed to read out thermal
 zone (-61)
From: Luciano Coelho <luciano.coelho@intel.com>
To: sedat.dilek@gmail.com
Cc: Zhang Rui <rui.zhang@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2018 18:01:06 +0300
In-Reply-To: <CA+icZUVUkLZxqqNocBg27_Q=xvtDbfuW7z1ZcDx+WNO0uDwuOA@mail.gmail.com>
References: <CA+icZUXxcxZvyo7ge33E_1PSnjUs7Lq=BdcX2rbB6pYka1S=cA@mail.gmail.com>
         <1b3e46335094bda8dfef48c74adf2d027e9417ca.camel@intel.com>
         <CA+icZUVUkLZxqqNocBg27_Q=xvtDbfuW7z1ZcDx+WNO0uDwuOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-20 at 16:45 +0200, Sedat Dilek wrote:
> On Thu, Sep 20, 2018 at 4:34 PM, Luciano Coelho
> <luciano.coelho@intel.com> wrote:
> > On Thu, 2018-09-20 at 15:42 +0200, Sedat Dilek wrote:
> > > Hi,
> > 
> > Hi,
> > 
> > 
> > > I am seeing this with Linux v4.18.y and v4.19-rc4.
> > > 
> > > Investigating thermal_zone3...
> > > 
> > > # cat /sys/devices/virtual/thermal/thermal_zone3/type
> > > iwlwifi
> > > 
> > > I have the following iwlwifi device and firmware installed...
> > > 
> > > [   10.476589] iwlwifi 0000:04:00.0: loaded firmware version
> > > 36.e91976c0.0 op_mode iwlmvm
> > > [   10.519441] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> > > Wireless AC 8265, REV=0x230
> > > 
> > > What informations do you need and how can I help?
> > 
> > This is normal, though annoying, and was discussed before.  The
> > thermal
> > framework is trying to read the temperature as soon as the zone is
> > registered and this causes that warning.  Our device only provides
> > the
> > temperature when the device goes up, so reading before that will
> > always
> > fail.
> > 
> 
> OK, I understand.
> Thanks.

Thanks for your interest in helping! :)

--
Cheers,
Luca.
