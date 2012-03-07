Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49940 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2CGJGz (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 7 Mar 2012 04:06:55 -0500
Received: by bkcik5 with SMTP id ik5so4976465bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 01:06:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
	<CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
Date: Wed, 7 Mar 2012 17:06:35 +0800
Message-ID: <CALx5=V98n26O88C2XkGnH8z69EKpRY6rejXxasTwZC=iZFTumA@mail.gmail.com> (sfid-20120307_100700_797670_B47D8ABE)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Matt Chen <machen@suse.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

2012/3/5 Mohammed Shafi <shafi.wireless@gmail.com>:
> Hi Matt,
>
>> echo 0x404c to which file in /sys/kernel/debug/ath9k ?
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x404c > regidx
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
>
> -> toggle the rfkill button, wifi off
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k#
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
>
> -> toggle the rfkill button, wifi ON
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
yes, those are working to me now, but see the file "regval", it is
allowed to be written. I tried to echo a value to it, and cat it, it
seems not work right to me. :(

You may try to echo "0x00000c45" > regval when the regval is
"0x00000c55". Then cat regval again, see if it changed to
"0x00000c45".
The case I tried, but is not working to me.
found the function in ath/ath9k/debug.c

static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
                             size_t count, loff_t *ppos)
{
        struct ath_softc *sc = file->private_data;
        struct ath_hw *ah = sc->sc_ah;
        unsigned long regval;
        char buf[32];
        ssize_t len;

        len = min(count, sizeof(buf) - 1);
        if (copy_from_user(buf, user_buf, len))
                return -EFAULT;

        buf[len] = '\0';
        if (strict_strtoul(buf, 0, &regval))
                return -EINVAL;

        ath9k_ps_wakeup(sc);
        REG_WRITE_D(ah, sc->debug.regidx, regval);
        ath9k_ps_restore(sc);
        return count;
}

then found
#define REG_WRITE_D(_ah, _reg, _val) \
        ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
So it would go to : ath/ath9k/init.c

static void ath9k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
{
        struct ath_hw *ah = (struct ath_hw *) hw_priv;
        struct ath_common *common = ath9k_hw_common(ah);
        struct ath_softc *sc = (struct ath_softc *) common->priv;

        if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
                unsigned long flags;
                spin_lock_irqsave(&sc->sc_serial_rw, flags);
                iowrite32(val, sc->mem + reg_offset);
                spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
        } else
                iowrite32(val, sc->mem + reg_offset);
}

Generally it should write value to to (sc->mem+reg_offset). But
actually the value of regval is not changed when you echo a value to
regval.

> please also see the dump of rfkill list, as i am external PCI card, my
> card is only softblocked.
>
> --
> thanks,
> shafi
>



-- 
Thank you.
