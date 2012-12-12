Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42825 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2LLTJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 14:09:35 -0500
Message-ID: <50C8D66D.4030601@openwrt.org> (sfid-20121212_200939_572113_36758405)
Date: Wed, 12 Dec 2012 20:09:33 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Daniel Golle <dgolle@allnet.de>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<helmut.schaa@googlemail.com>" <helmut.schaa@googlemail.com>,
	"<john@phrozen.org>" <john@phrozen.org>
Subject: Re: [PATCH 1/3] rt2x00: allow overriding eeprom through platform_data
References: <20121211100350.GA7813@earthship.arig> <555EAC65-09DC-466A-AAC8-4896E08D9F5D@gmail.com>
In-Reply-To: <555EAC65-09DC-466A-AAC8-4896E08D9F5D@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.11. 22:40 keltezéssel, Gertjan van Wingerde írta:
> Hi Daniel,
> 
> On 11 dec. 2012, at 11:03, Daniel Golle <dgolle@allnet.de> wrote:
> 
>>
>> Signed-off-by: Daniel Golle <dgolle@allnet.de>
> 
> We really need a proper patch description, explaining why the patch is needed. You explained in the intro [0 / 3], but that one isn't committed to git. So, to have some proper information in the git log we need the info included in the patch itself.
> 
> See also below for some concerns on the changes themselves.
> 
> 
>>
>> create mode 100644 drivers/net/wireless/rt2x00/rt2x00eeprom.c
>> create mode 100644 include/linux/rt2x00_platform.h
>>
>> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
>> index c7548da..e3b9dab 100644
>> --- a/drivers/net/wireless/rt2x00/Kconfig
>> +++ b/drivers/net/wireless/rt2x00/Kconfig
>> @@ -60,6 +60,7 @@ config RT2800PCI
>>    select RT2X00_LIB_PCI if PCI
>>    select RT2X00_LIB_SOC if RALINK_RT288X || RALINK_RT305X
>>    select RT2X00_LIB_FIRMWARE
>> +    select RT2X00_LIB_EEPROM
>>    select RT2X00_LIB_CRYPTO
>>    select CRC_CCITT
>>    select EEPROM_93CX6
>> @@ -212,6 +213,9 @@ config RT2X00_LIB_FIRMWARE
>> config RT2X00_LIB_CRYPTO
>>    boolean
>>
>> +config RT2X00_LIB_EEPROM
>> +    boolean
>> +
>> config RT2X00_LIB_LEDS
>>    boolean
>>    default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
> 
> I find the approach very complicated, with all the general facilities that
> are only used by rt2800.

The idea behind the generic approach was that the feature can be used for
EEPROM-less rt2500/rt61 based PCI devices as well. However I did not find any
such device yet, so the rt2500/rt61 part was never implemented.

> Why not read the eeprom file directly from rt2800pci.c, with an directly
> coded call to request_firmware, instead of reading it at another place and
> then only copying it later.

You are right, things would be much simpler this way. If someone ever encounter
a board with a rt2500/rt61 chip which needs this feature, the generalization can
happen later.

<...>

>> +static void rt2800pci_read_eeprom_file(struct rt2x00_dev *rt2x00dev)
>> {
>> +    memcpy(rt2x00dev->eeprom, rt2x00dev->eeprom_file->data, EEPROM_SIZE);
>> }
>> -#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
> 
> I meant with the previous comment to read the file right here, instead of at
> a different place in the code.

True.

>> #ifdef CONFIG_PCI
>> static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
>> @@ -322,6 +312,20 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
>> }
>>
>> /*
>> + * EEPROM file functions.
>> + */
>> +static char *rt2800pci_get_eeprom_file_name(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    struct rt2x00_platform_data *pdata;
>> +
>> +    pdata = rt2x00dev->dev->platform_data;
>> +    if (pdata)
>> +        return pdata->eeprom_file_name;
>> +
>> +    return NULL;
>> +}
>> +
>> +/*
> 
> That would make this redundant.

Yes.

> 
>>  * Initialization functions.
>>  */
>> static bool rt2800pci_get_entry_state(struct queue_entry *entry)
>> @@ -972,8 +976,9 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
>>  */
>> static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
>> {
>> -    if (rt2x00_is_soc(rt2x00dev))
>> -        rt2800pci_read_eeprom_soc(rt2x00dev);
>> +    if (rt2x00_is_soc(rt2x00dev) ||
>> +        test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
>> +        rt2800pci_read_eeprom_file(rt2x00dev);
>>    else if (rt2800pci_efuse_detect(rt2x00dev))
>>        rt2800pci_read_eeprom_efuse(rt2x00dev);
>>    else
>> @@ -1033,6 +1038,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
>>    .get_firmware_name    = rt2800pci_get_firmware_name,
>>    .check_firmware        = rt2800_check_firmware,
>>    .load_firmware        = rt2800_load_firmware,
>> +    .get_eeprom_file_name   = rt2800pci_get_eeprom_file_name,
>>    .initialize        = rt2x00pci_initialize,
>>    .uninitialize        = rt2x00pci_uninitialize,
>>    .get_entry_state    = rt2800pci_get_entry_state,
> 
> And this part as well.

Yes.

<...>

>> @@ -989,6 +992,11 @@ struct rt2x00_dev {
>>    const struct firmware *fw;
>>
>>    /*
>> +     * EEPROM image.
>> +     */
>> +    const struct firmware *eeprom_file;
>> +
>> +    /*
>>     * FIFO for storing tx status reports between isr and tasklet.
>>     */
>>    DECLARE_KFIFO_PTR(txstatus_fifo, u32);
> 
> And this would not be needed at all, as the struct firmware could be local to
> the firmware reading function.

Ok.

<...>
>> +static int rt2x00lib_request_eeprom_file(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    const struct firmware *ee;
>> +    char *ee_name;
>> +    int retval;
>> +
>> +    ee_name = rt2x00dev->ops->lib->get_eeprom_file_name(rt2x00dev);
>> +    if (!ee_name) {
>> +        ERROR(rt2x00dev,
>> +              "Invalid EEPROM filename.\n"
>> +              "Please file bug report to %s.\n", DRV_PROJECT);
>> +        return -EINVAL;
>> +    }
>> +
>> +    INFO(rt2x00dev, "Loading EEPROM data from '%s'.\n", ee_name);
>> +
>> +    retval = request_firmware(&ee, ee_name, rt2x00dev->dev);
>> +    if (retval) {
>> +        ERROR(rt2x00dev, "Failed to request EEPROM.\n");
>> +        return retval;
>> +    }
> 
> And here is the biggest problem of this patch. Request_firmware is 
> synchronous and will fail when userspace isn't up yet. For built-in versions
> of the driver userspace isn't up yet at this point of time, so this will fail
> then.

Yes, this should be asynchronous. The original patch was developed two years ago
and I was not aware of the asynchronous version of request_firmware at that
time. Because OpenWrt uses the compat-wireless package so the driver is always
loaded as a module, I did not bother to change this.

Thank you for the review!

-Gabor

