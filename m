Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:58916 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1ANXis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 18:38:48 -0500
Subject: htc dream wl1251 and MSM_GPIO_TO_INT(29)
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 00:33:13 +0100
Message-ID: <1295047993.24338.66.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,
In the TI driver available here:
http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=blob;f=sta_dk_4_0_4_32/pform/linux/src/esta_drv.c;h=a968e20bebf6c22f9983d0a6db50b40f04f1f1e8;hb=refs/heads/froyo
there is:
#define TROUT_IRQ MSM_GPIO_TO_INT(29)
[...]
if (drv->irq)
    [...]
    if ((rc = request_irq (drv->irq, (irq_handler_t)tiwlan_interrupt,
IRQF_SHARED | IRQF_TRIGGER_FALLING /*Dm:*/, drv->netdev->name,
drv))){//error message}
    [...]
    set_irq_type (drv->irq, IRQ_TYPE_EDGE_FALLING);
    [...]
    disable_irq (drv->irq);

So we learn several things here:
*it uses MSM_GPIO_TO_INT(29)
*the irq configuration.

So I took the 2.6.32 kernel version available here:
http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/android-msm-2.6.32-rebase

I also took an old compat-wireless driver(because more recent ones have
the runtime PM capability and I don't know how to make it work with an
old 2.6.32 kernel that lacks such patches)
The version is this one compat-wireless-2010-10-04

I modified both the kernel and compat wireless to be able to pass the
wl12xx struct directly, like in recent kernels, and it seem to work.

The problem is the following:
When I do that:
modprobe msm_wifi, wich is the old wifi activator from bob copeland
available here:
http://bobcopeland.com/srcs/android/msm_wifi.patch

it freeze the phone, and watch -n 0.1 cat /proc/interupts trough ssh
seem frozen too

Here's the code for passing the data :

static void trout_wl1251_init(void)
{
        struct wl12xx_platform_data trout_wl1251_pdata;
        int ret;

        trout_wl1251_pdata.irq = MSM_GPIO_TO_INT(29);
        if (trout_wl1251_pdata.irq < 0)
                goto fail_irq;
        trout_wl1251_pdata.use_eeprom = false;
        ret = wl12xx_set_platform_data(&trout_wl1251_pdata);
        if (ret < 0)
                goto fail_irq;
fail_irq:
        printk("trout wifi GPIO failed\n");
        gpio_free(TROUT_WIFI_IRQ_GPIO);

}

The data is beeing passed(else it wouldn't freesze) and the phone
freezes.

note that the compat wireless irq handling code is different from the ti
driver:
if (wl->irq) {
    ret = request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
    if (ret < 0) {
        wl1251_error("request_irq() failed: %d", ret);
                goto disable;
    }

     set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
     disable_irq(wl->irq);

     wl1251_sdio_ops.enable_irq = wl1251_enable_line_irq;
     wl1251_sdio_ops.disable_irq = wl1251_disable_line_irq;

     wl1251_info("using dedicated interrupt line");
}

in the TI driver there is IRQ_TYPE_EDGE_FALLING while here there is
IRQ_TYPE_EDGE_RISING.

How should I start debugging that issue? do I need a serial cable for my
device and kgdb(doesn't serial need IRQ?, maybe I should look how msm
serial works)?

Denis.



