Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from scl-exch2k.phoenix.com ([134.122.225.253]:9276 "HELO
	scl-exch2k.phoenix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933484AbZLMBfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 20:35:13 -0500
From: Satanand Burla <Satanand_Burla@phoenix.com>
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 12 Dec 2009 14:58:12 -0800
Subject: ath9k ps poll performance 
Message-ID: <6D80BDFB1A1FA74DA476417C24C452A10251AB5773@scl-exch2k7.phoenix.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 
        I have AR9285 card on  a netbook and I am using the latest compat-wirless drivers from   http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

        I am trying to use  PS POLL on the ath9k driver,  So I applied  this  
        http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-12-08/ath9k-ps-enable.patch 
       patch from here on top of latest compat-wireless. 
           
        I have tried to use only pspoll without mac80211's dynamic_ps_timeout by setting the dynamic_ps_timeout to 0. 

         using 
                    iwconfig wlan0 power timeout 0
                    iwconfig wlan0 power on.

          I do not have any connection problems with this setup (as reported by others http://bugzilla.kernel.org/show_bug.cgi?id=14267) but  I find that the performance is very slow. 

          for example with the same  wep AP, I get around 150 to 200 Kbps without enabling ps poll. but if I enable ps poll with the above settings, I get only around 20 Kbps and the packet loss is around 20 to 30%. 

          My question is, is this the expected speed drop when turning on ps poll ? Or is this a problem with the driver that still needs to be addressed ?
            
           I did enable ATH_DBG_PS and the ps poll sequence seems to going well ( detecting aid in tim,  sending ps poll frame, picking buffered frames , going back to sleep). 

           I have also verified that the following patchset is already applied on the latest compat-wireless that I am trying. Unfortunately I am stuck with a 2.6.27 kernel and cannot test the latest wireless testing tree. 
           
             http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-12-08/for-2.6.32/
 

           Any help will be highly appreciated.

            
           Here is the lspci -vv of my ath9k card Please let me know if any other information is needed.


     05:00.0 Network controller: Atheros Communications Inc. Device 002b (rev 01)
    Subsystem: Askey Computer Corp. Device 7167
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f0100000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
        Address: 00000000  Data: 0000
    Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Kernel driver in use: ath9k

Regards,
Satanand
