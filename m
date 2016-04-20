Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33372 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbcDTBYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 21:24:07 -0400
Received: by mail-yw0-f174.google.com with SMTP id t10so38137668ywa.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 18:24:07 -0700 (PDT)
Subject: Re: [PATCH 1/4] NFC: trf7970a: Add support for gpio as SS
To: linux-wireless <linux-wireless@vger.kernel.org>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
 <1461008921-15100-2-git-send-email-geoff@kuvee.com>
 <CAGRGNgWMLUaRAbxoNdmP3fsRX+W=8DY7Gcw-z6phJv7BnZp6-Q@mail.gmail.com>
 <CAO7Z3WJofeT4agChaZ-NQ5TwrMygdGRhG7myJkNuEb9i_g-Y=A@mail.gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>, mgreer@animalcreek.com,
	Justin Bronder <justin@kuvee.com>
From: Geoffrey Lansberry <geoff@kuvee.com>
Message-ID: <5716DA34.3070201@kuvee.com> (sfid-20160420_032421_431358_078D5D27)
Date: Tue, 19 Apr 2016 21:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAO7Z3WJofeT4agChaZ-NQ5TwrMygdGRhG7myJkNuEb9i_g-Y=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Julian suggests, this is handled by the cs-gpios property, so we will 
drop this patch, but keep the other three active.

Thanks for the suggestion.
>
> On Mon, Apr 18, 2016 at 8:07 PM, Julian Calaby 
> <julian.calaby@gmail.com <mailto:julian.calaby@gmail.com>> wrote:
>
>     Hi Geoff,
>
>     On Tue, Apr 19, 2016 at 5:48 AM, Geoff Lansberry <geoff@kuvee.com
>     <mailto:geoff@kuvee.com>> wrote:
>     > Signed-off-by: Geoff Lansberry <geoff@kuvee.com
>     <mailto:geoff@kuvee.com>>
>
>     Can't you just use the cs-gpios property? This should require no
>     driver changes.
>
>     This is described here:
>
>     https://www.kernel.org/doc/Documentation/devicetree/bindings/spi/spi-bus.txt
>
>     Thanks,
>
>     Julian Calaby
>
>
>     > ---
>     >  .../devicetree/bindings/net/nfc/trf7970a.txt  |  2 ++
>     >  drivers/nfc/trf7970a.c  | 33 ++++++++++++++++++++--
>     >  2 files changed, 33 insertions(+), 2 deletions(-)
>     >
>     > diff --git
>     a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>     b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>     > index 32b35a0..09c5056 100644
>     > --- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>     > +++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>     > @@ -7,6 +7,7 @@ Required properties:
>     >  - interrupts: A single interrupt specifier.
>     >  - ti,enable-gpios: Two GPIO entries used for 'EN' and 'EN2'
>     pins on the
>     >    TRF7970A.
>     > +- ti,ss-gpio: GPIO entry used for active low SS (spi slave
>     select) on the TRF7970A
>     >  - vin-supply: Regulator for supply voltage to VIN pin
>     >
>     >  Optional SoC Specific Properties:
>     > @@ -37,6 +38,7 @@ Example (for ARM-based BeagleBone with
>     TRF7970A on SPI1):
>     >                 interrupts = <14 0>;
>     >                 ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_LOW>,
>     >                                   <&gpio2 5 GPIO_ACTIVE_LOW>;
>     > +               ti,ss-gpio = <&gpio2 4 GPIO_ACTIVE_HIGH>;
>     >                 vin-supply = <&ldo3_reg>;
>     >                 vin-voltage-override = <5000000>;
>     >                 autosuspend-delay = <30000>;
>     > diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
>     > index 10842b7..2c3530a 100644
>     > --- a/drivers/nfc/trf7970a.c
>     > +++ b/drivers/nfc/trf7970a.c
>     > @@ -450,6 +450,7 @@ struct trf7970a {
>     >         bool adjust_resp_len;
>     >         int                             en2_gpio;
>     >         int                             en_gpio;
>     > +       int                             ss_gpio;
>     >         struct mutex                    lock;
>     >         unsigned int                    timeout;
>     >         bool ignore_timeout;
>     > @@ -462,9 +463,11 @@ static int trf7970a_cmd(struct trf7970a
>     *trf, u8 opcode)
>     >         u8 cmd = TRF7970A_CMD_BIT_CTRL |
>     TRF7970A_CMD_BIT_OPCODE(opcode);
>     >         int ret;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         dev_dbg(trf->dev, "cmd: 0x%x\n", cmd);
>     >
>     >         ret = spi_write(trf->spi, &cmd, 1);
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         if (ret)
>     >                 dev_err(trf->dev, "%s - cmd: 0x%x, ret: %d\n",
>     __func__, cmd,
>     >                                 ret);
>     > @@ -476,7 +479,9 @@ static int trf7970a_read(struct trf7970a
>     *trf, u8 reg, u8 *val)
>     >         u8 addr = TRF7970A_CMD_BIT_RW | reg;
>     >         int ret;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         ret = spi_write_then_read(trf->spi, &addr, 1, val, 1);
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         if (ret)
>     >                 dev_err(trf->dev, "%s - addr: 0x%x, ret: %d\n",
>     __func__, addr,
>     >                                 ret);
>     > @@ -493,6 +498,7 @@ static int trf7970a_read_cont(struct
>     trf7970a *trf, u8 reg, u8 *buf, size_t len)
>     >         struct spi_message m;
>     >         int ret;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         dev_dbg(trf->dev, "read_cont(0x%x, %zd)\n", addr, len);
>     >
>     >         spi_message_init(&m);
>     > @@ -508,6 +514,7 @@ static int trf7970a_read_cont(struct
>     trf7970a *trf, u8 reg, u8 *buf, size_t len)
>     >         spi_message_add_tail(&t[1], &m);
>     >
>     >         ret = spi_sync(trf->spi, &m);
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         if (ret)
>     >                 dev_err(trf->dev, "%s - addr: 0x%x, ret: %d\n",
>     __func__, addr,
>     >                                 ret);
>     > @@ -519,9 +526,11 @@ static int trf7970a_write(struct trf7970a
>     *trf, u8 reg, u8 val)
>     >         u8 buf[2] = { reg, val };
>     >         int ret;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         dev_dbg(trf->dev, "write(0x%x): 0x%x\n", reg, val);
>     >
>     >         ret = spi_write(trf->spi, buf, 2);
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         if (ret)
>     >                 dev_err(trf->dev, "%s - write: 0x%x 0x%x, ret:
>     %d\n", __func__,
>     >                                 buf[0], buf[1], ret);
>     > @@ -535,6 +544,7 @@ static int trf7970a_read_irqstatus(struct
>     trf7970a *trf, u8 *status)
>     >         u8 buf[2];
>     >         u8 addr;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         addr = TRF7970A_IRQ_STATUS | TRF7970A_CMD_BIT_RW;
>     >
>     >         if (trf->quirks & TRF7970A_QUIRK_IRQ_STATUS_READ) {
>     > @@ -544,6 +554,7 @@ static int trf7970a_read_irqstatus(struct
>     trf7970a *trf, u8 *status)
>     >                 ret = spi_write_then_read(trf->spi, &addr, 1,
>     buf, 1);
>     >         }
>     >
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         if (ret)
>     >                 dev_err(trf->dev, "%s - irqstatus: Status read
>     failed: %d\n",
>     >                                 __func__, ret);
>     > @@ -559,6 +570,7 @@ static int trf7970a_read_target_proto(struct
>     trf7970a *trf, u8 *target_proto)
>     >         u8 buf[2];
>     >         u8 addr;
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         addr = TRF79070A_NFC_TARGET_PROTOCOL | TRF7970A_CMD_BIT_RW |
>     >                 TRF7970A_CMD_BIT_CONTINUOUS;
>     >
>     > @@ -569,6 +581,7 @@ static int trf7970a_read_target_proto(struct
>     trf7970a *trf, u8 *target_proto)
>     >         else
>     >                 *target_proto = buf[0];
>     >
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     >         return ret;
>     >  }
>     >
>     > @@ -663,6 +676,7 @@ static int trf7970a_transmit(struct trf7970a
>     *trf, struct sk_buff *skb,
>     >         print_hex_dump_debug("trf7970a tx data: ", DUMP_PREFIX_NONE,
>     >                         16, 1, skb->data, len, false);
>     >
>     > +       gpio_set_value(trf->ss_gpio, 0);
>     >         spi_message_init(&m);
>     >
>     >         memset(&t, 0, sizeof(t));
>     > @@ -679,7 +693,7 @@ static int trf7970a_transmit(struct trf7970a
>     *trf, struct sk_buff *skb,
>     >         if (ret) {
>     >                 dev_err(trf->dev, "%s - Can't send tx data:
>     %d\n", __func__,
>     >                                 ret);
>     > -               return ret;
>     > +               goto out_err;
>     >         }
>     >
>     >         skb_pull(skb, len);
>     > @@ -706,7 +720,9 @@ static int trf7970a_transmit(struct trf7970a
>     *trf, struct sk_buff *skb,
>     >
>     >  schedule_delayed_work(&trf->timeout_work,
>     msecs_to_jiffies(timeout));
>     >
>     > -       return 0;
>     > +out_err:
>     > +       gpio_set_value(trf->ss_gpio, 1);
>     > +       return ret;
>     >  }
>     >
>     >  static void trf7970a_fill_fifo(struct trf7970a *trf)
>     > @@ -2039,6 +2055,19 @@ static int trf7970a_probe(struct
>     spi_device *spi)
>     >                 return ret;
>     >         }
>     >
>     > +       trf->ss_gpio = of_get_named_gpio(np, "ti,ss-gpio", 0);
>     > +       if (!gpio_is_valid(trf->ss_gpio)) {
>     > +               dev_err(trf->dev, "No SS GPIO property\n");
>     > +               return trf->ss_gpio;
>     > +       }
>     > +
>     > +       ret = devm_gpio_request_one(trf->dev, trf->ss_gpio,
>     > +                       GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
>     "trf7970a SS");
>     > +       if (ret) {
>     > +               dev_err(trf->dev, "Can't request SS GPIO: %d\n",
>     ret);
>     > +               return ret;
>     > +       }
>     > +
>     >         if (of_property_read_bool(np, "en2-rf-quirk"))
>     >                 trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
>     >
>     > --
>     > 1.9.1
>     >
>     > --
>     > To unsubscribe from this list: send the line "unsubscribe
>     linux-wireless" in
>     > the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     > More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
>     --
>     Julian Calaby
>
>     Email: julian.calaby@gmail.com <mailto:julian.calaby@gmail.com>
>     Profile: http://www.google.com/profiles/julian.calaby/
>
>
>
>
> -- 
> Geoff Lansberry
>
>
> Engineering Guy
> Kuvée, Inc
> 125 Kingston St., 3rd Floor
> Boston, MA 02111
> 1-617-290-1118 (m)
> geoff.lansberry (skype)
> http://www.kuvee.com
> <http://www.kuvee.com>
>

