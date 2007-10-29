Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:14550 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXJ2VBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 17:01:37 -0400
Message-ID: <4726497F.2010709@oracle.com> (sfid-20071029_210140_076562_A23E009D)
Date: Mon, 29 Oct 2007 13:58:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, j@w1.fi,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hostap: fix section mismatch warning
References: <20071029112026.f66473c5.randy.dunlap@oracle.com> <20071029205254.GA27547@tuxdriver.com>
In-Reply-To: <20071029205254.GA27547@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Oct 29, 2007 at 11:20:26AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix section mismatch warning:
>>
>> WARNING: vmlinux.o(.data+0x36fcc): Section mismatch: reference to .init.data:prism2_pci_id_table (between 'prism2_pci_drv_id' and 'prism2_pci_funcs')
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  drivers/net/wireless/hostap/hostap_pci.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> --- linux-2624-rc1g4-v1.orig/drivers/net/wireless/hostap/hostap_pci.c
>> +++ linux-2624-rc1g4-v1/drivers/net/wireless/hostap/hostap_pci.c
>> @@ -444,7 +444,7 @@ static int prism2_pci_resume(struct pci_
>>  
>>  MODULE_DEVICE_TABLE(pci, prism2_pci_id_table);
>>  
>> -static struct pci_driver prism2_pci_drv_id = {
>> +static struct pci_driver prism2_pci_driver = {
>>  	.name		= "hostap_pci",
>>  	.id_table	= prism2_pci_id_table,
>>  	.probe		= prism2_pci_probe,
> 
> Randy,
> 
> Would you mind explaining how changing the name of the pci_driver
> variable resolves this?  There must be some magic here...

Oh, sure.  In scripts/mod/modpost.c, there is a whitelist of variable
name suffixes.  Those suffixes are assumed to be safe for referring
to non-text code/data.  OTOH, if someone complains enough, another
whitelist table element can also be added...


/**
 * Whitelist to allow certain references to pass with no warning.
 *
 * Pattern 0:
 *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
 *   The pattern is identified by:
 *   fromsec = .text.init.refok* | .data.init.refok*
 *
 * Pattern 1:
 *   If a module parameter is declared __initdata and permissions=0
 *   then this is legal despite the warning generated.
 *   We cannot see value of permissions here, so just ignore
 *   this pattern.
 *   The pattern is identified by:
 *   tosec   = .init.data
 *   fromsec = .data*
 *   atsym   =__param*
 *
 * Pattern 2:
 *   Many drivers utilise a *driver container with references to
 *   add, remove, probe functions etc.
 *   These functions may often be marked __init and we do not want to
 *   warn here.
 *   the pattern is identified by:
 *   tosec   = init or exit section
 *   fromsec = data section
 *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
 *
 * Pattern 3:
 *   Whitelist all refereces from .text.head to .init.data
 *   Whitelist all refereces from .text.head to .init.text
 *
 * Pattern 4:
 *   Some symbols belong to init section but still it is ok to reference
 *   these from non-init sections as these symbols don't have any memory
 *   allocated for them and symbol address and value are same. So even
 *   if init section is freed, its ok to reference those symbols.
 *   For ex. symbols marking the init section boundaries.
 *   This pattern is identified by
 *   refsymname = __init_begin, _sinittext, _einittext
 *
 * Pattern 5:
 *   Xtensa uses literal sections for constants that are accessed PC-relative.
 *   Literal sections may safely reference their text sections.
 *   (Note that the name for the literal section omits any trailing '.text')
 *   tosec = <section>[.text]
 *   fromsec = <section>.literal
 **/
static int secref_whitelist(const char *modname, const char *tosec,
			    const char *fromsec, const char *atsym,
			    const char *refsymname)
{
	int len;
	const char **s;
	const char *pat2sym[] = {
		"driver",
		"_template", /* scsi uses *_template a lot */
		"_timer",    /* arm uses ops structures named _timer a lot */
		"_sht",      /* scsi also used *_sht to some extent */
		"_ops",
		"_probe",
		"_probe_one",
		"_console",
		NULL
	};

	const char *pat3refsym[] = {
		"__init_begin",
		"_sinittext",
		"_einittext",
		NULL
	};

-- 
~Randy
