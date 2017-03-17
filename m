Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:35463 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdCQMon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 08:44:43 -0400
Received: by mail-ot0-f171.google.com with SMTP id x37so89545022ota.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 05:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1698550.OFukYSGa7m@prime>
References: <20170316151337.24163-1-sw@simonwunderlich.de> <20170316151337.24163-4-sw@simonwunderlich.de>
 <CALhHN=qNXW6FVr_Q4B7pmLN2UVywa2dWdZtnhwV+9AAqUO=EAQ@mail.gmail.com> <1698550.OFukYSGa7m@prime>
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Fri, 17 Mar 2017 13:44:41 +0100
Message-ID: <CALhHN=roObX1H3V8=LrOP4QJk8PYyc6kHt_KmPmVrx28Lg9MLw@mail.gmail.com> (sfid-20170317_134504_816797_A4FF38D8)
Subject: Re: [PATCH 3/3] ath9k: add noise floor override option
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 March 2017 at 09:55, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> On Friday, March 17, 2017 9:48:07 AM CET Janusz Dziedzic wrote:
>> On 16 March 2017 at 16:13, Simon Wunderlich <sw@simonwunderlich.de> wrote:
>> > Introduce a debugfs option to manually override the noise floor,
>> > ignoring the automatically tuned noise floor of the driver/hw.
>> >
>> > In my tests with a AR9580 based module and a tx99 5 MHz interferer,
>> > I could tune the noisefloor to -95 dBm or above to allow communication
>> > again. The automatic noise floor calibration sometimes could adapt to
>> > the situation as well, but not reliably and permanently.
>> >
>> > I would consider this "feature" experimental and interesting for people
>> > debugging the noise floor calibration or other effects of the hardware.
>> >
>> > Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
>> > Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
>> > ---
>> >
>> >  drivers/net/wireless/ath/ath9k/calib.c |  5 ++-
>> >  drivers/net/wireless/ath/ath9k/debug.c | 62
>> >  ++++++++++++++++++++++++++++++++++ drivers/net/wireless/ath/ath9k/hw.h
>> >   |  1 +
>> >  3 files changed, 67 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/calib.c
>> > b/drivers/net/wireless/ath/ath9k/calib.c index 0f71146b781d..13ab6bc46775
>> > 100644
>> > --- a/drivers/net/wireless/ath/ath9k/calib.c
>> > +++ b/drivers/net/wireless/ath/ath9k/calib.c
>> > @@ -254,7 +254,9 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct
>> > ath9k_channel *chan)>
>> >                         if ((i >= AR5416_MAX_CHAINS) &&
>> >                         !IS_CHAN_HT40(chan))
>> >
>> >                                 continue;
>> >
>> > -                       if (h)
>> > +                       if (ah->nf_override)
>> > +                               nfval = ah->nf_override;
>> > +                       else if (h)
>> >
>> >                                 nfval = h[i].privNF;
>> >
>> >                         else
>> >
>> >                                 nfval = default_nf;
>> >
>> > @@ -348,6 +350,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct
>> > ath9k_channel *chan)>
>> >         return 0;
>> >
>> >  }
>> >
>> > +EXPORT_SYMBOL(ath9k_hw_loadnf);
>> >
>> >  static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/debug.c
>> > b/drivers/net/wireless/ath/ath9k/debug.c index 43930c336987..2e64977a8ab6
>> > 100644
>> > --- a/drivers/net/wireless/ath/ath9k/debug.c
>> > +++ b/drivers/net/wireless/ath/ath9k/debug.c
>> > @@ -1191,6 +1191,65 @@ static const struct file_operations fops_tpc = {
>> >
>> >         .llseek = default_llseek,
>> >
>> >  };
>> >
>> > +static ssize_t read_file_nf_override(struct file *file,
>> > +                                    char __user *user_buf,
>> > +                                    size_t count, loff_t *ppos)
>> > +{
>> > +       struct ath_softc *sc = file->private_data;
>> > +       struct ath_hw *ah = sc->sc_ah;
>> > +       char buf[32];
>> > +       unsigned int len;
>> > +
>> > +       if (ah->nf_override == 0)
>> > +               len = sprintf(buf, "off\n");
>> > +       else
>> > +               len = sprintf(buf, "%d\n", ah->nf_override);
>> > +
>> > +       return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>> > +}
>> > +
>> > +static ssize_t write_file_nf_override(struct file *file,
>> > +                                     const char __user *user_buf,
>> > +                                     size_t count, loff_t *ppos)
>> > +{
>> > +       struct ath_softc *sc = file->private_data;
>> > +       struct ath_hw *ah = sc->sc_ah;
>> > +       long val;
>> > +       char buf[32];
>> > +       ssize_t len;
>> > +
>> > +       len = min(count, sizeof(buf) - 1);
>> > +       if (copy_from_user(buf, user_buf, len))
>> > +               return -EFAULT;
>> > +
>> > +       buf[len] = '\0';
>> > +       if (strncmp("off", buf, 3) == 0)
>> > +               val = 0;
>> > +       else if (kstrtol(buf, 0, &val))
>> > +               return -EINVAL;
>> > +
>> > +       if (val > 0)
>> > +               return -EINVAL;
>> > +
>> > +       if (val < -120)
>> > +               return -EINVAL;
>> > +
>> > +       ah->nf_override = val;
>> > +
>> > +       if (ah->curchan)
>> > +               ath9k_hw_loadnf(ah, ah->curchan);
>> > +
>> > +       return count;
>> > +}
>> > +
>> > +static const struct file_operations fops_nf_override = {
>> > +       .read = read_file_nf_override,
>> > +       .write = write_file_nf_override,
>> > +       .open = simple_open,
>> > +       .owner = THIS_MODULE,
>> > +       .llseek = default_llseek,
>> > +};
>> > +
>> >
>> >  /* Ethtool support for get-stats */
>> >
>> >  #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
>> >
>> > @@ -1402,5 +1461,8 @@ int ath9k_init_debug(struct ath_hw *ah)
>> >
>> >         debugfs_create_u16("airtime_flags", S_IRUSR | S_IWUSR,
>> >
>> >                            sc->debug.debugfs_phy, &sc->airtime_flags);
>> >
>> > +       debugfs_create_file("nf_override", S_IRUSR | S_IWUSR,
>> > +                           sc->debug.debugfs_phy, sc, &fops_nf_override);
>> > +
>>
>> Why not simply:
>>         debugfs_create_u32("nf_override", S_IRUSR|S_IWUSR ,
>> sc->debug.debugfs_phy,
>>                           &ah->nf_override);
>>
>> One line patch :)
>
> Thanks Janusz, good idea! That doesn't check the limits, which is probably not
> a big deal anyway. What bothers me more is that it doesn't update the noise
> floor immediately (ath9k_hw_loadnf()), which would be nice to have. Otherwise
> you have to wait up to ~30 seconds or so until the noise floor is updated next
> time. So I'd keep my variant for now, unless you have a good idea to fix the
> latter. :)
>
I see, seems I miss ath9k_hw_loadnf() call :)

> Cheers,
>       Simon
