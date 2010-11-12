Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57952 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab0KLPzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 10:55:52 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PGvyh-0003XY-81
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 16:55:51 +0100
Received: from function.justgohome.co.uk ([217.169.15.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 16:55:51 +0100
Received: from rb-oss-3 by function.justgohome.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 16:55:51 +0100
To: linux-wireless@vger.kernel.org
From: Robie Basak <rb-oss-3@justgohome.co.uk>
Subject: Re: r8187se panic
Date: Fri, 12 Nov 2010 15:55:37 +0000 (UTC)
Message-ID: <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
 <4CDC9FA5.10002@lwfinger.net>
 <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk>
 <4CDD3BC4.7070102@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

The patches have helped - thanks!

Failure case A:
  1) Boot with AC power connected and wireless on
  2) Switch wireless off
  3) Kernel panic

With just the change_panic_to_warn patch, case A works fine now.
However, the following sequence of events now causes some sort of
infinite loop (with lots of stack traces in dmesg) instead of a hang
like it did before:

Failure case B:
  1) Boot with AC power connected and wireless on
  2) Suspend
  3) Resume (and Network Manager kicks in to reconnect etc)
  4) Remove AC power
  5) (wait a few seconds)
  6) Some sort of loop with lots being dumped to dmesg, no wireless
connection resumes

With the addition of the lock_pci_remove patch, case B goes away too.
However, adding more to the failure case still causes problems:

Failure case C:
  1) Boot with AC power connected and wireless on
  2) Suspend
  3) Resume (and Network Manager kicks in to reconnect etc)
  4) Remove AC power
  5) (wait a few seconds)
  6) Restore AC power
  7) (wireless disconnects; some sort of loop in dmesg; it does manage
to associate at times but this never lasts long)
  8) (network Manager gives up) but the loop in dmesg continues
  9) Reloading the module and toggling the wireless switch seems to fix
     it

Note that I can work around cases B and C by having
SUSPEND_MODULES=r8187se in /etc/pm/config.d. The original problem does
seem to be resolved. Case C also seems pretty non-deterministic. I can't
reproduce it reliably. I have also managed to cause a hang using various
combinations of switching AC power, suspend and the wireless switch but
I haven't managed to reproduce it.

All of the stuff in dmesg I could see seems to be the same RE|WE bits
not clear stack trace from your patch.

Does this help? Is there anything else I can do?

Thanks,

Robie

On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> This is a multi-part message in MIME format.
> --------------070405020109010304050501
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: 7bit
>
> On 11/12/2010 05:06 AM, Robie Basak wrote:
>> On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 11/11/2010 06:41 PM, Robie Basak wrote:
>>>> I'm getting a panic when I to turn off the wireless using the Fn-F2
>>>> combination on my Asus Eee PC 701SDX. Although I'm using Ubuntu 10.10,
>>>> I've tried it using the mainline kernel (as supplied by Ubuntu for
>>>> testing bugs against mainline). So far I've reproduced consistently
>>>> against Ubuntu's 2.6.35-22-generic-pae as well as Ubuntu-supplied
>>>> mainstream 2.6.35-02063504.201008271919 and
>>>> 2.6.37-020637rc1.201011020905.
>>>
>>> Is Fn-F2 the radio kill switch?
>> 
>> Yes, that's right.
>> 
>>> At this point, I see no point in building a mainstream kernel.
>>>
>>> Do you have another host that might be setup as a net console?
>> 
>> Yes, I managed to get net console working (eventually):
>> 
>> (the first four lines are from when I modprobed r8187se)
>> 
>> [  941.787361] r8187se: module is from the staging directory, the quality is unknown, you have been warned.
>> [  941.821968] rtl8180_init:Error channel plan! Set to default.
>> [  941.825000] Dot11d_Init()
>> [  941.877241] r8180: WW:**PLEASE** REPORT SUCCESSFUL/UNSUCCESSFUL TO Realtek!
>> [  947.318002] ------------[ cut here ]------------
>> [  947.321315] WARNING: at /home/kernel-ppa/COD/linux/fs/proc/generic.c:816 remove_proc_entry+0x1e5/0x240()
>> [  947.328160] Hardware name: 701SDX
>> [  947.331607] name 'wlan0'
>> [  947.334987] Modules linked in: r8187se(C) netconsole eeprom_93cx6 parport_pc ppdev binfmt_misc snd_hda_codec_realtek snd_hda_intel i915 snd_hda_codec snd_hwdep snd_pcm drm_kms_helper joydev snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq drm snd_timer snd_seq_device intel_agp i2c_algo_bit intel_gtt snd psmouse eeepc_laptop video shpchp soundcore serio_raw agpgart sparse_keymap snd_page_alloc output led_class lp parport atl1e configfs [last unloaded: r8187se]
>> [  947.354968] Pid: 1350, comm: kworker/0:2 Tainted: G        WC  2.6.37-020637rc1-generic #201011020905
>> [  947.363331] Call Trace:
>> [  947.367541]  [<c02700d5>] ? remove_proc_entry+0x1e5/0x240
>
> --snip--
>
>> [  947.491911] Kernel panic - not syncing: HwThreeWire(): CmdReg: 0XFF RE|WE bits are not clear!!
>> [  947.491916] 
>> [  947.498375] Pid: 1350, comm: kworker/0:2 Tainted: G        WC  2.6.37-020637rc1-generic #201011020905
>> [  947.505177] Call Trace:
>> [  947.508561]  [<c014f90f>] panic+0x5f/0x190
>> [  947.511965]  [<e02ccd3f>] HwHSSIThreeWire+0x4f/0x270 [r8187se]
>> [  947.515424]  [<e02ccfd2>] RF_WriteReg+0x32/0x40 [r8187se]
>> [  947.518877]  [<e02cb29a>] rtl8225z2_rf_close+0x1a/0x50 [r8187se]
>> [  947.522384]  [<e02dd885>] rtl8180_pci_remove+0x45/0x107 [r8187se]
>> [  947.525861]  [<c0420206>] ? __pm_runtime_resume+0x46/0x60
>> [  947.529347]  [<c038372a>] pci_device_remove+0
>
> Thanks for the netconsole output. That helps a lot.
>
> The warning in remove_proc_entry() is essentially harmless. I'll take care of
> that later.
>
> The driver should never panic over a condition as trivial as the RE/WE bits are
> not zero. I missed that when I worked on the original version of the driver. As
> the bits are all 1, it appears that the device is partially disabled before this
> code is reached. One thing I notice is that there is no lock around the
> unregister_netdevice() call.
>
> Attached are two patches. One changes the panic statements into log entries with
> a stack dump, and the second provides a lock for the call noted above. The first
> patch cannot cause any problems; however, the second may cause the machine to
> freeze. At least with the first, the system will no longer crash.
>
> While you are testing these, I'll try to sort out why there is a warning in
> remove_proc_entry().
>
> Larry
>
>
>
>
> --------------070405020109010304050501
> Content-Type: text/plain;
>  name="rtl8187se_change_panic_to_warn"
> Content-Transfer-Encoding: 7bit
> Content-Disposition: attachment;
>  filename="rtl8187se_change_panic_to_warn"
>
> Index: linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
>===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8187se/r8185b_init.c
> +++ linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
> @@ -264,8 +264,12 @@ HwHSSIThreeWire(
>  
>  			udelay(10);
>  		}
> -		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT)
> -			panic("HwThreeWire(): CmdReg: %#X RE|WE bits are not clear!!\n", u1bTmp);
> +		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
> +			printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
> +			       " %#X RE|WE bits are not clear!!\n", u1bTmp);
> +			dump_stack();
> +			return 0;
> +		}
>  
>  		/* RTL8187S HSSI Read/Write Function */
>  		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
> @@ -298,13 +302,23 @@ HwHSSIThreeWire(
>  				int idx;
>  				int ByteCnt = nDataBufBitCnt / 8;
>  								/* printk("%d\n",nDataBufBitCnt); */
> -				if ((nDataBufBitCnt % 8) != 0)
> -				panic("HwThreeWire(): nDataBufBitCnt(%d) should be multiple of 8!!!\n",
> -				nDataBufBitCnt);
> -
> -			       if (nDataBufBitCnt > 64)
> -				panic("HwThreeWire(): nDataBufBitCnt(%d) should <= 64!!!\n",
> -				nDataBufBitCnt);
> +				if ((nDataBufBitCnt % 8) != 0) {
> +					printk(KERN_ERR "rtl8187se: "
> +					       "HwThreeWire(): nDataBufBitCnt(%d)"
> +					       " should be multiple of 8!!!\n",
> +					       nDataBufBitCnt);
> +					dump_stack();
> +					nDataBufBitCnt += 8;
> +					nDataBufBitCnt &= ~7;
> +				}
> +
> +			       if (nDataBufBitCnt > 64) {
> +					printk(KERN_ERR "rtl8187se: HwThreeWire():"
> +					       " nDataBufBitCnt(%d) should <= 64!!!\n",
> +					       nDataBufBitCnt);
> +					dump_stack();
> +					nDataBufBitCnt = 64;
> +				}
>  
>  				for (idx = 0; idx < ByteCnt; idx++)
>  					write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
>
> --------------070405020109010304050501
> Content-Type: text/plain;
>  name="rtl8187se_lock_pci_remove"
> Content-Transfer-Encoding: 7bit
> Content-Disposition: attachment;
>  filename="rtl8187se_lock_pci_remove"
>
> Index: linux-2.6/drivers/staging/rtl8187se/r8180_core.c
>===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
> +++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
> @@ -3656,12 +3656,15 @@ static void __devexit rtl8180_pci_remove
>  {
>  	struct r8180_priv *priv;
>  	struct net_device *dev = pci_get_drvdata(pdev);
> +	unsigned long flags;
>  
>  	if (dev) {
> -		unregister_netdev(dev);

