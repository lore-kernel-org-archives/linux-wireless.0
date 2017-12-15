Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755136AbdLOKdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 05:33:03 -0500
Date: Fri, 15 Dec 2017 11:32:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4356 does not initalize after firmware update
Message-ID: <20171215103215.GA2742@redhat.com> (sfid-20171215_113423_102082_FAFAB04C)
References: <20171213161257.GB2811@redhat.com>
 <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com>
 <5A339CB2.1040202@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A339CB2.1040202@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 15, 2017 at 10:58:10AM +0100, Arend van Spriel wrote:
> On 12/14/2017 3:22 PM, Stanislaw Gruszka wrote:
> >On Thu, Dec 14, 2017 at 10:13:29AM +0100, Arend van Spriel wrote:
> >>The cur_etheraddr is the first piece of info we try to get from the
> >>firmware. Could you build the driver with CONFIG_BRCMDBG and load
> >>the module with 'debug=0x181416'.
> >
> >dmesg attached.
> 
> So the firmware console output in the dmesg shows partial stack
> trace which clearly means the firmware crashed.
> 
> [ 2685.701602] brcmfmac: brcmf_pcie_isr_thread Enter 100
> [ 2685.701613] brcmfmac: brcmf_pcie_handle_mb_data D2H_MB_DATA: 0x10000000
> [ 2685.701634] brcmfmac: CONSOLE: 0d
> [ 2685.701706] brcmfmac: CONSOLE: 000000.049 sp+ec 00184635
> [ 2685.701778] brcmfmac: CONSOLE: 000000.049 sp+f4 00182ca7
> [ 2685.701854] brcmfmac: CONSOLE: 000000.049 sp+100 000001df
> [ 2685.701928] brcmfmac: CONSOLE: 000000.049 sp+140 0000823f
> [ 2685.702003] brcmfmac: CONSOLE: 000000.049 sp+150 0018b8d9
> [ 2687.642667] brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on
> response for query command
> [ 2687.650464] brcmfmac: brcmf_fil_cmd_data Failed: BCME_NOTDOWN (-5)
> [ 2687.650469] brcmfmac: brcmf_fil_iovar_data_get ifidx=0,
> name=cur_etheraddr, len=6
> [ 2687.650471] brcmutil: data
> [ 2687.650475] 00000000: 00 00 00 00 00 00   ......
> [ 2687.650479] brcmfmac: brcmf_c_preinit_dcmds: Retreiving
> cur_etheraddr failed, -5
> 
> I noticed you are not using a nvram file. Do you know if one was
> orignally provided with the device?

I think it was not. The device was bought and setup in Fedora/RHEL
machine, which do not include any extra brcmfmac nvram file.

Thanks
Stanislaw
