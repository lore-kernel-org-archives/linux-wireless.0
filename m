Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:57705 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAaGRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 01:17:22 -0500
Message-ID: <1391149038.22155.33.camel@porter.coelho.fi> (sfid-20140131_071725_888445_9D4681EC)
Subject: Re: wlcore-spi crash
From: Luca Coelho <luca@coelho.fi>
To: Charles <hobbesc7@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 31 Jan 2014 08:17:18 +0200
In-Reply-To: <CAKKnJbfTUf01uLxS199GP_BMkjEw5LWBKNGQQ4v1Q98gPkp2qw@mail.gmail.com>
References: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com>
	 <CAFED-jmUF9u=sLfVuCSy3rjmB4DM9x6BCLhJaq2CrY9MV6Wycg@mail.gmail.com>
	 <CAKKnJbeVqvUUnW7E7yw3cvF_1DKw5_+xpYJ+jB3U-=VL=vQyVg@mail.gmail.com>
	 <CAKKnJbe+bqnTv3BOai3YoyMzNZ3w3gY460O0d1GiZDZaZYg5Uw@mail.gmail.com>
	 <CAKKnJbfTUf01uLxS199GP_BMkjEw5LWBKNGQQ4v1Q98gPkp2qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Charles,

On Thu, 2014-01-30 at 17:20 -0500, Charles wrote:
> So my hack was obviously not the right solution, because I'm not
> powering the chip.  I know that in wlcore\spi.c, I need to set a
> .power function in spi_ops (i.e. .power = wl12xx_spi_power).  And I
> already have a wl12xx_platform_data with a .set_power function defined
> in my board platform file.  But I don't know how to access my platform
> file's set_power function from the wl12xx_spi_power function in spi.c.
> 
> In other words, I can' figure out how to do this from wlcore\spi.c:
> 
> static int wl12xx_spi_power(struct device *child, bool enable) {
> 
>     set_power_function_defined_in_my_board_platform_file(enable);
> 
> }

Try this:


diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index b2c018d..1278583 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -316,6 +316,16 @@ static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
        return 0;
 }
 
+static int wl12xx_spi_power(struct device *child, bool enable)
+{
+       struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
+       struct wlcore_platdev_data *pdev_data = glue->core->dev.platform_data;
+
+       pdev_data->pdata->set_power(enable);
+
+       return 0;
+}
+
 static struct wl1271_if_operations spi_ops = {
        .read           = wl12xx_spi_raw_read,
        .write          = wl12xx_spi_raw_write,

Note that this is only compile-tested, so I have no clue if it really
works.

I'm *not* saying this is the right way to do it, I just hacked it up
quickly.

I hope this helps you go in the right direction.

--
Luca.

