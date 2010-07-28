Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab0G1AFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 20:05:15 -0400
Subject: Re: [BUG] after starting wimaxd at boot iwlagn module will crash
 for intel 6250 card
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Sternberg, Jay E" <jay.e.sternberg@intel.com>,
	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: "alexxy@gentoo.org" <alexxy@gentoo.org>,
	"wimax@linuxwimax.org" <wimax@linuxwimax.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1280270313.26204.288.camel@localhost.localdomain>
References: <201007280028.48674.alexxy@gentoo.org>
	 <1280270313.26204.288.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Jul 2010 17:04:38 -0700
Message-Id: <1280275478.12970.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2010-07-27 at 15:38 -0700, Inaky Perez-Gonzalez wrote:
> On Tue, 2010-07-27 at 13:28 -0700, Alexey Shvetsov wrote: 
> > Hi all!
> 
> [apologies, I forgot to mention to CC the linux-wireless mailing list,
> where the iwlagn guys lurk around -- done].
> 
> Guys, seems the wifi device is tripping in the 6250 when we switch on
> WiMAX. Do you see anything interesting?
> 
> > Seems i fund bug on my 64bit system. I have installed 32bit version
> > of wimax stack 1.5 and i'm running 2.6.35-rc6 kernel. 
> > 
> > After starting
> > wimaxd at boot time iwlagn driver will crash when i try to scan or connect
> > to any network. Stacktrace will be the following
> > 
> > iwlagn 0000:02:00.0:
> > RF_KILL bit toggled to enable radio.
> > i2400m_usb 2-1.3:1.0: 'RF Control'
> > (0x4602) command failed: -84 - invalid state (3)
> > iwlagn 0000:02:00.0:
> > Microcode SW error detected.  Restarting 0x2000000.
> > iwlagn 0000:02:00.0:
> > Loaded firmware version: 9.201.4.1 build 24255
> > iwlagn 0000:02:00.0: Start
> > IWL Error Log Dump:
> > iwlagn 0000:02:00.0: Status: 0x00020224, count: 5
> > iwlagn
> > 0000:02:00.0: Desc                               Time       data1      data2
> >      line
> > iwlagn 0000:02:00.0: SYSASSERT                    (#05) 0000012334
> > 0x0000008D 0x8000000D 453
> > iwlagn 0000:02:00.0: pc      blink1  blink2 
> > ilink1  ilink2  hcmd
> > iwlagn 0000:02:00.0: 0x1D074 0x1D066 0x1D066 0x009B2
> > 0x00000 0x400005A
> > iwlagn 0000:02:00.0: CSR values:
> > iwlagn 0000:02:00.0: (2nd
> > byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> > iwlagn 0000:02:00.0:    
> >    CSR_HW_IF_CONFIG_REG: 0X00480303
> > iwlagn 0000:02:00.0:         
> > CSR_INT_COALESCING: 0X0000ff40
> > iwlagn 0000:02:00.0:                    
> > CSR_INT: 0X00000000
> > iwlagn 0000:02:00.0:                CSR_INT_MASK:
> > 0X00000000
> > iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
> > 0X00000000
> > iwlagn 0000:02:00.0:                 CSR_GPIO_IN:
> > 0X0000000f
> > iwlagn 0000:02:00.0:                   CSR_RESET:
> > 0X00000000
> > iwlagn 0000:02:00.0:                CSR_GP_CNTRL:
> > 0X080403c5
> > iwlagn 0000:02:00.0:                  CSR_HW_REV:
> > 0X00000084
> > iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
> > 0Xe0a20ffd
> > iwlagn 0000:02:00.0:               CSR_EEPROM_GP:
> > 0X90000801
> > iwlagn 0000:02:00.0:              CSR_OTP_GP_REG:
> > 0X00030001
> > iwlagn 0000:02:00.0:                 CSR_GIO_REG:
> > 0X00080046
> > iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG:
> > 0X00000002
> > iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
> > 0X00000004
> > iwlagn 0000:02:00.0:           CSR_UCODE_DRV_GP1:
> > 0X00000000
> > iwlagn 0000:02:00.0:           CSR_UCODE_DRV_GP2:
> > 0X00000000
> > iwlagn 0000:02:00.0:                 CSR_LED_REG:
> > 0X00000018
> > iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
> > 0X00000000
> > iwlagn 0000:02:00.0:        CSR_GIO_CHICKEN_BITS:
> > 0X27800200
> > iwlagn 0000:02:00.0:             CSR_ANA_PLL_CFG:
> > 0X00000000
> > iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG:
> > 0X0001001a
> > iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
> > 0Xffff0000
> > iwlagn 0000:02:00.0: FH register values:
> > iwlagn 0000:02:00.0:    
> >     FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
> > iwlagn 0000:02:00.0:       
> > FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
> > iwlagn 0000:02:00.0:              
> >    FH_RSCSR_CHNL0_WPTR: 0X00000000
> > iwlagn 0000:02:00.0:        
> > FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
> > iwlagn 0000:02:00.0:         
> > FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlagn 0000:02:00.0:           
> > FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlagn 0000:02:00.0:   
> > FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> > iwlagn 0000:02:00.0:          
> >      FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlagn 0000:02:00.0:                
> > FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlagn 0000:02:00.0: Start IWL Event Log
> > Dump: display last 20 entries
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004384:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004385:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004385:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004387:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004388:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004388:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004389:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004390:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004391:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004391:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004392:0x000000ff:1100
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004402:0x000003b1:0601
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004402:0x10000000:0600
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004403:0x000003c1:0660
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000004407:0x00000000:0661
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000012227:0x0400005a:0401
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000012228:0x0400005a:1513
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000012228:0x00000000:1513
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000012229:0x00000001:1523
> > iwlagn 0000:02:00.0:
> > EVT_LOGT:0000012344:0x00000000:0125
> > iwlagn 0000:02:00.0: Command
> > REPLY_PHY_CALIBRATION_CMD failed: FW Error
> > iwlagn 0000:02:00.0: Error -5
> > iteration 0
> > usb 1-1.4: new full speed USB device using ehci_hcd and address
> > 5
> > iwlagn 0000:02:00.0: Error sending CALIBRATION_CFG_CMD: time out after
> > 500ms.
> > Bluetooth: Generic Bluetooth USB driver ver 0.6
> > usbcore: registered
> > new interface driver btusb
> > Bluetooth: BNEP (Ethernet Emulation) ver
> > 1.3
> > Bluetooth: BNEP filters: protocol multicast
> > Bluetooth: SCO (Voice Link)
> > ver 0.6
> > Bluetooth: SCO socket layer initialized
> > iwlagn 0000:02:00.0:
> > START_ALIVE timeout after 4000ms.
> > 
> > 
Looks like iwlwifi driver stuck on loading uCode and performing
WiFi/WiMAX coex operation. I will forward the information to our uCode
team to look into it.

Thanks
Wey

