Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2EHOu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 10:50:28 -0400
Received: by yhmm54 with SMTP id m54so5391349yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 07:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
References: <loom.20101104T140201-178@post.gmane.org> <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 8 May 2012 07:50:06 -0700
Message-ID: <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com> (sfid-20120508_165032_649101_E4F0252F)
Subject: Re: Adding custom channels to ath5k for researching purposes
To: Bob Copeland <me@bobcopeland.com>
Cc: Vadim <Vadims.Kurmis@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 7:47 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Nov 4, 2010 at 9:03 AM, Vadim <Vadims.Kurmis@gmail.com> wrote:
>> I need to enable 802.11p standard frequencies. How can I accomplish this? I
>> found that CRDA is responsible for allowed channels.
>
> Partially -- the channel list is exported by the driver but CRDA
> adds additional regulatory restrictions.  The driver also imposes
> certain regulatory restrictions based on the EEPROM data.
>
>> So, where can I get binary
>> frequency/channel database to use my hardware for researching purposes ?
>
> You can create your own database, but you may need to modify the driver to
> disregard the EEPROM settings, with the usual disclaimers: we won't support
> it and if it breaks you get to keep both pieces.
>
> Also note that ath5k only advertises a partial channel list; you can
> get more via all_channels=1 modparam.  We don't do this by default
> because they make scanning take forever and exceed channel list limits
> in netlink.

I'm thinking it may make sense to add CONFIG_WIRELESS_EXPERT where we
can stuff some of this stuff under. It may be useful for other
regulatory testing / certification stuff.

  Luis
