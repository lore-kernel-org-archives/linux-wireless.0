Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64672 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767Ab2HJXmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 19:42:08 -0400
Received: by ggdk6 with SMTP id k6so2206909ggd.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 16:42:07 -0700 (PDT)
Date: Fri, 10 Aug 2012 18:42:02 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] bcma: add cc core driver, expose sprom to sysfs
Message-ID: <20120810234202.GA8644@eris.garyseven.net> (sfid-20120811_014213_847962_A39C6BB2)
References: <20120810002305.GA5966@eris.garyseven.net>
 <CACna6rz83DOTDYG1ehd-dvMoWrnduvJ44Lpi3vM0wMLMrC0-hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rz83DOTDYG1ehd-dvMoWrnduvJ44Lpi3vM0wMLMrC0-hA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 06:55:22AM +0200, Rafał Miłecki wrote:
> 2012/8/10 Saul St. John <saul.stjohn@gmail.com>:
> > Adds a driver for BCMA ChipCommon cores, registers the struct device
> > bcma_bus.drv_cc->core->dev with device_register(), and exposes the SPROM
> > in rev 31+ cc cores as a R/W sysfs attribute.
> 
> Well, that's a little messy. You change a few not strictly related
> things in a one patch, please provide patch-per-change. That changes
> are quite sensitive so we really need it.

Ok, v2 will be split over a couple of patches.

> I also wish to see some explanation on that changes. Why do you need
> CC to be registered as a bus core device? Why anyone may need
> overwriting SPROM? Did it work for you? Have you tested
> suspend&resume?

Conceptually, the SPROM appears to be a function of the CC core (in rev 31+),
and /not/ of the PCI device (as it is in ssb), so it seemed appropriate to 
hang the sprom attribute off that. 

That didn't work, though, because the device struct within drv_cc wasn't 
registered. Once I registered the device, it still didn't work, because BCMA
assumes that devices on the bus all have bcma_drivers. So I wrote one.

I was really confused by the drv_cc structure in general; the name suggests
a driver, and the structure suggests a device, but it's treated like a 
component of the bus. It makes more sense to me when structured like this, 
but I'm really just looking to expose the SPROM for rewriting /somewhere/ in 
sysfs.

I've tested changing the PCI subsystem IDs, the MAC address, and the country
code using ssb-sprom from b43-tools. It works fine on my 0x4331, although
I can't test suspend/resume, because it causes (unrelated) crashes. That's the
only device I have access to.

> 
> > +static ssize_t bcma_core_cc_attr_sprom_store(struct device *dev,
> > +                                               struct device_attribute *attr,
> > +                                               const char *buf, size_t count)
> > +{
> > +       u16 *sprom;
> > +       int err, i;
> > +
> > +       struct bcma_device *core = container_of(dev, struct bcma_device, dev);
> > +
> > +       sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16), GFP_KERNEL);
> > +       if (!sprom)
> > +               return -ENOMEM;
> > +
> > +       err = bcma_sprom_fromhex(sprom, buf, count);
> > +       if (!err)
> > +               err = bcma_sprom_valid(sprom);
> > +       if (err)
> > +               goto out_kfree;
> > +
> > +       if (mutex_lock_interruptible(&core->dev.mutex)) {
> > +               err = -ERESTARTSYS;
> > +               goto out_kfree;
> > +       }
> > +
> > +       if (core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
> > +           core->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
> > +               bcma_chipco_bcm4331_ext_pa_lines_ctl(&core->bus->drv_cc,
> > +                                                    false);
> > +
> > +       bcma_warn(core->bus,
> > +               "Writing SPROM. Do NOT turn off the power! "
> > +               "Please stand by...\n");
> 
> No line-breaking please.
> 
> 
> > +       bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WREN, 0, 0);
> 
> Maybe you should check for an error (at least here!), I believe we
> should be really careful when writing SPROM.

I thought about it, but I don't know how (or if!) the CC core can signal an
error during SPROM write. AFAICT, the busy-flag eventually clears whether the
operation succeeds or not. Besides, if there were an error, what should happen
next? 

Judging from the bcmsrom.c file that was in the bcm80211 staging tree, 
Broadcom doesn't think this operation can fail.

> > +
> > +       msleep(500);
> > +
> > +       for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++) {
> > +               if (i == SSB_SPROMSIZE_WORDS_R4 / 4)
> > +                       bcma_warn(core->bus, "SPROM write 25%% complete.\n");
> > +               else if (i == SSB_SPROMSIZE_WORDS_R4 / 2)
> > +                       bcma_warn(core->bus, "SPROM write 50%% complete.\n");
> > +               else if (i == (SSB_SPROMSIZE_WORDS_R4 * 3) / 4)
> > +                       bcma_warn(core->bus, "SPROM write 75%% complete.\n");
> > +               bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WRITE,
> > +                                i, sprom[i]);
> > +               msleep(20);
> > +       }
> > +
> > +       bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WRDIS, 0, 0);
> > +
> > +       msleep(500);
> > +
> > +       bcma_warn(core->bus, "SPROM wrte complete.\n");
> > +
> > +       if (core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
> > +           core->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
> > +               bcma_chipco_bcm4331_ext_pa_lines_ctl(&core->bus->drv_cc,
> > +                                                    true);
> > +
> > +       mutex_unlock(&core->dev.mutex);
> > +
> > +       bcma_sprom_extract_r8(core->bus, sprom);
> > +
> > +out_kfree:
> > +       kfree(sprom);
> > +
> > +       return err ? err : count;
> > +}
> > +
> > +static DEVICE_ATTR(sprom, 0600, bcma_core_cc_attr_sprom_show,
> > +                               bcma_core_cc_attr_sprom_store);
> > +
> > +
> > +static int bcma_core_cc_probe(struct bcma_device *core)
> >  {
> >         u32 leddc_on = 10;
> >         u32 leddc_off = 90;
> >
> > -       if (cc->setup_done)
> > -               return;
> > +       struct bcma_drv_cc *cc = &core->bus->drv_cc;
> >
> > -       if (cc->core->id.rev >= 11)
> > -               cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
> > -       cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
> > -       if (cc->core->id.rev >= 35)
> > -               cc->capabilities_ext = bcma_cc_read32(cc, BCMA_CC_CAP_EXT);
> > +       if (core->id.rev >= 11)
> > +               cc->status = bcma_read32(core, BCMA_CC_CHIPSTAT);
> > +       cc->capabilities = bcma_read32(core, BCMA_CC_CAP);
> > +       if (core->id.rev >= 35)
> > +               cc->capabilities_ext = bcma_read32(core, BCMA_CC_CAP_EXT);
> >
> > -       if (cc->core->id.rev >= 20) {
> > -               bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, 0);
> > -               bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, 0);
> > +       if (core->id.rev >= 20) {
> > +               bcma_write32(core, BCMA_CC_GPIOPULLUP, 0);
> > +               bcma_write32(core, BCMA_CC_GPIOPULLDOWN, 0);
> >         }
> >
> >         if (cc->capabilities & BCMA_CC_CAP_PMU)
> >                 bcma_pmu_init(cc);
> >         if (cc->capabilities & BCMA_CC_CAP_PCTL)
> > -               bcma_err(cc->core->bus, "Power control not implemented!\n");
> > +               bcma_err(core->bus, "Power control not implemented!\n");
> >
> > -       if (cc->core->id.rev >= 16) {
> > -               if (cc->core->bus->sprom.leddc_on_time &&
> > -                   cc->core->bus->sprom.leddc_off_time) {
> > -                       leddc_on = cc->core->bus->sprom.leddc_on_time;
> > -                       leddc_off = cc->core->bus->sprom.leddc_off_time;
> > +       if (core->id.rev >= 16) {
> > +               if (core->bus->sprom.leddc_on_time &&
> > +                   core->bus->sprom.leddc_off_time) {
> > +                       leddc_on = core->bus->sprom.leddc_on_time;
> > +                       leddc_off = core->bus->sprom.leddc_off_time;
> >                 }
> >                 bcma_cc_write32(cc, BCMA_CC_GPIOTIMER,
> >                         ((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
> >                          (leddc_off << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT)));
> >         }
> >
> > +       if (core->id.rev >= 31 &&
> > +           cc->capabilities & BCMA_CC_CAP_SPROM)
> > +               device_create_file(&cc->core->dev, &dev_attr_sprom);
> > +
> >         cc->setup_done = true;
> > +       return 0;
> > +}
> > +
> > +
> > +static void bcma_core_cc_remove(struct bcma_device *core)
> > +{
> > +       if (core->id.rev >= 31 &&
> > +           core->bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM)
> > +               device_remove_file(&core->dev, &dev_attr_sprom);
> > +}
> > +
> > +static struct bcma_device_id bcma_core_cc_id_table[] = {
> > +       BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_CHIPCOMMON,
> > +                 BCMA_ANY_REV, BCMA_ANY_CLASS),
> > +       BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_4706_CHIPCOMMON,
> > +                 BCMA_ANY_REV, BCMA_ANY_CLASS),
> > +       BCMA_CORETABLE_END
> > +};
> > +
> > +struct bcma_driver bcma_core_cc_driver = {
> > +       .name     = "bcma-cc-core",
> > +       .probe    = bcma_core_cc_probe,
> > +       .remove   = bcma_core_cc_remove,
> > +       .id_table = bcma_core_cc_id_table,
> > +};
> > +
> > +static void bcma_core_cc_release(struct device *dev)
> > +{
> > +       struct bcma_device *core = container_of(dev, struct bcma_device, dev);
> > +
> > +       kfree(core);
> > +}
> > +
> > +void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
> > +{
> 
> It doesn't init anymore, does it?

It still does, just in bcma_core_cc_probe.
 
> > +       int err;
> > +
> > +       if (cc->setup_done)
> > +               return;
> 
> You will get CC core device re-registered on every suspend&resume (see
> setup_done).

You're right.

> Hm, actually, suspend&resume probably won't work anymore, as you don't
> re-init ChipCommon.
 
Got it. Will the ChipCommon core always be the first device in bus->cores?
If so, I'll add re-initialization to bcma_core_cc_resume, and lose the 
special handling in bcma_bus_resume.

> > +       cc->core->dev.bus = bcma_core_cc_driver.drv.bus;
> > +       cc->core->dev.release = bcma_core_cc_release;
> > +       dev_set_name(&cc->core->dev, "bcma%d:%d",
> > +                    cc->core->bus->num, cc->core->core_index);
> > +
> > +       if (cc->core->bus->hosttype == BCMA_HOSTTYPE_PCI)
> > +               cc->core->dev.parent = &cc->core->bus->host_pci->dev;
> > +
> > +       err = device_register(&cc->core->dev);
> > +       if (err) {
> > +               bcma_err(cc->core->bus,
> > +                        "Could not register dev for core 0x%03X\n",
> > +                        cc->core->id.id);
> > +       } else
> > +               cc->core->dev_registered = true;
> >  }
> >
> >  /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
> > diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> > index 758af9c..9ceaca3 100644
> > --- a/drivers/bcma/main.c
> > +++ b/drivers/bcma/main.c
> > @@ -109,7 +109,8 @@ static int bcma_register_cores(struct bcma_bus *bus)
> >
> >                 core->dev.release = bcma_release_core_dev;
> >                 core->dev.bus = &bcma_bus_type;
> > -               dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
> > +               dev_set_name(&core->dev, "bcma%d:%d",
> > +                            bus->num, core->core_index);
> 
> I've noticed this just yesterday. Didn't you get warning about unused dev_id?
> 

Nope, because I also forgot to remove dev_id++. :-)

Question: is the memory kzalloc'd in bcma_bus_scan for the PCI, MIPS, and (w/o 
this patch) CC cores leaked when the module is unloaded?

> -- 
> Rafał
