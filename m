Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37415 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932208AbdLTIrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 03:47:03 -0500
Received: by mail-wm0-f41.google.com with SMTP id f140so8178132wmd.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 00:47:02 -0800 (PST)
Subject: Re: BCM4356 does not initalize after firmware update
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20171213161257.GB2811@redhat.com> <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com> <5A339CB2.1040202@broadcom.com>
 <20171215103215.GA2742@redhat.com> <5A33ADAA.9060008@broadcom.com>
 <20171215122045.GB2742@redhat.com> <5A38F9C4.3050202@broadcom.com>
 <20171219122340.GA13135@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A3A2383.1080103@broadcom.com> (sfid-20171220_094712_046099_9122C7E9)
Date: Wed, 20 Dec 2017 09:46:59 +0100
MIME-Version: 1.0
In-Reply-To: <20171219122340.GA13135@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------030108080702040903080303"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030108080702040903080303
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/2017 1:23 PM, Stanislaw Gruszka wrote:
> On Tue, Dec 19, 2017 at 12:36:36PM +0100, Arend van Spriel wrote:
>> On 12/15/2017 1:20 PM, Stanislaw Gruszka wrote:
>>> On Fri, Dec 15, 2017 at 12:10:34PM +0100, Arend van Spriel wrote:
>>>> # cat /sys/kernel/debug/brcmfmac/0000:03:00.0/revinfo
>>>
>>> vendorid: 0x14e4
>>> deviceid: 0x43ec
>>> radiorev: 0.41.32.105
>>> chipnum: 17238 (4356)
>>> chiprev: 2
>>> chippkg: 2
>>> corerev: 48
>>> boardid: 0x0777
>>> boardvendor: 0x14e4
>>> boardrev: P103
>>> driverrev: 7.35.180.119
>>> ucoderev: 0
>>> bus: 0
>>> phytype: 11
>>> phyrev: 17
>>> anarev: 0
>>> nvramrev: 00000000
>>
>> Thanks for the info. I was looking for the board info. It seems we
>> do not have an nvram file for that specific board.
>>
>> For SDIO devices I would suggest to use the module parameter
>> 'ignore_probe_fail' so we could do post-mortem stuff with the driver
>> bound to the device, but for PCIe there are not much debug options.
>> Let me work on that. May take a bit longer though.
>
> What about the revert of the firmware change if proper
> fix can not be soon available ?

Hi Stanislaw,

I had my colleague run some tests as he has the device, but he is an 
ocean away. So he could get the new firmware running with nvram file. 
For the old firmware the device could boot without nvram, but the scan 
results were showing that the device was not operating optimally. Could 
you try the new firmware with the attached sample nvram file and let me 
know if that works for you?

Regards,
Arend


--------------030108080702040903080303
Content-Type: text/plain; charset=UTF-8;
 name="bcm94356wlpagbl.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bcm94356wlpagbl.txt"

# Sample variables file for BCM94356 WLBGA iPA, eLNA+switch board with PCIe for production package
# Following fields WILL be written into OTP

# Following fields WILL NOT be written in OTP  
# [NVRAM ONLY]
NVRAMRev=$Rev: 500242 $
sromrev=11
boardrev=0x1101
macaddr=00:90:4c:19:80:01
boardtype=0x0732
boardflags=0x12401201
#enable LNA1 bypass for both 2G & 5G
boardflags2=0x00802000
boardflags3=0x4800018a
#boardnum=57410 
ccode=0
regrev=0
antswitch=0
pdgain5g=4
pdgain2g=4
tworangetssi2g=0
tworangetssi5g=0
paprdis=0
femctrl=10
vendid=0x14e4
devid=0x43ec
manfid=0x2d0
#prodid=0x052e
nocrc=1
otpimagesize=484
xtalfreq=37400
rxgains2gtrelnabypa0=1
rxgains2gtrelnabypa1=1
#2G elna gain from datasheet is 14dB
#2G elna gain changed to 12dB
rxgains2gelnagaina0=3
rxgains2gelnagaina1=3
#triso values for 2G are picked from older nvram. Might need to change.
rxgains2gtrisoa0=6
rxgains2gtrisoa1=6
rxgains5gtrelnabypa0=1
rxgains5gmtrelnabypa0=1
rxgains5ghtrelnabypa0=1
rxgains5gtrelnabypa1=1
rxgains5gmtrelnabypa1=1
rxgains5ghtrelnabypa1=1
#5G elna gain from datasheet is 12dB
rxgains5gelnagaina0=3
rxgains5gmelnagaina0=3
rxgains5ghelnagaina0=3
rxgains5gelnagaina1=3
rxgains5gmelnagaina1=3
rxgains5ghelnagaina1=3
#triso values for 5G are picked from older nvram. Might need to change.
rxgains5gtrisoa0=5
rxgains5gmtrisoa0=6
rxgains5ghtrisoa0=6
rxgains5gtrisoa1=5
rxgains5gmtrisoa1=6
rxgains5ghtrisoa1=6
rxchain=3
txchain=3
aa2g=3
aa5g=3
agbg0=2
agbg1=2
aga0=2
aga1=2
tssipos2g=1
extpagain2g=2
tssipos5g=1
extpagain5g=2
tempthresh=120
tempoffset=255
rawtempsense=0x1ff
#pa2ga0=-98,6012,-652
#pa2ga1=-37,6488,-663
#pa5ga0=-74,5929,-633,-74,5928,-631,-57,5987,-615,-37,6048,-613
#pa5ga1=18,6630,-645,-8,6498,-665,47,6774,-637,26,6741,-651
#pa2ga0=-169,6154,-729
#pa2ga1=-149,6457,-741
#pa2ga0=-134,6229,-696_used 
#pa2ga1=-150,6023,-688_used
pa2ga0=-135,6154,-693
pa2ga1=-133,6240,-702
pa2gccka0=-128,6716,-762
pa2gccka1=-124,6801,-767
#pa5ga0=-163,6233,-728,-162,6270,-730,-170,6227,-730,-169,6213,-729_used
#pa5ga1=-171,6217,-734,-178,6130,-730,-176,6202,-734,-177,6175,-733_used
pa5ga0=-176,6230,-750,-167,6386,-758,-180,6285,-754,-182,6269,-759
pa5ga1=-197,5998,-740,-190,6158,-754,-200,6029,-742,-175,6414,-763
subband5gver=0x4
pdoffsetcckma0=0x0
pdoffsetcckma1=0x0
pdoffset40ma0=0x0000
pdoffset80ma0=0x0000
pdoffset40ma1=0x0000
pdoffset80ma1=0x0000
maxp2ga0=74
maxp5ga0=74,74,74,74
maxp2ga1=74
maxp5ga1=74,74,74,74
cckbw202gpo=0x0000
cckbw20ul2gpo=0x0000
mcsbw202gpo=0xa9855422
mcsbw402gpo=0xa9855422
dot11agofdmhrbw202gpo=0x5542
ofdmlrbw202gpo=0x0022
mcsbw205glpo=0xa9866663
mcsbw405glpo=0xa9866663
mcsbw805glpo=0xbb866665
mcsbw205gmpo=0xd9866663
mcsbw405gmpo=0xa9866663
mcsbw805gmpo=0xcc866665
mcsbw205ghpo=0xdc866663
mcsbw405ghpo=0xaa866663
mcsbw805ghpo=0xdd866665
mcslr5glpo=0x0000
mcslr5gmpo=0x0000
mcslr5ghpo=0x0000
sb20in40hrpo=0x0
sb20in80and160hr5glpo=0x0
sb40and80hr5glpo=0x0
sb20in80and160hr5gmpo=0x0
sb40and80hr5gmpo=0x0
sb20in80and160hr5ghpo=0x0
sb40and80hr5ghpo=0x0
sb20in40lrpo=0x0
sb20in80and160lr5glpo=0x0
sb40and80lr5glpo=0x0
sb20in80and160lr5gmpo=0x0
sb40and80lr5gmpo=0x0
sb20in80and160lr5ghpo=0x0
sb40and80lr5ghpo=0x0
dot11agduphrpo=0x0
dot11agduplrpo=0x0
phycal_tempdelta=25
temps_period=15
temps_hysteresis=15
AvVmid_c0=2,140,2,145,2,145,2,145,2,145
AvVmid_c1=2,140,2,145,2,145,2,145,2,145
AvVmid_c2=0,0,0,0,0,0,0,0,0,0
rssicorrnorm_c0=1,1
rssicorrnorm_c1=1,1
rssicorrnorm5g_c0=3,3,4,2,2,2,1,2,1,1,0,2
rssicorrnorm5g_c1=3,1,3,1,1,2,0,0,1,-1,0,1
epsdelta2g0=0
epsdelta2g1=0
ofdmfilttype=1
swctrlmap_2g=0x00001040,0xC0300000,0x40200000,0x803020,0x0ff
swctrlmap_5g=0x00000202,0x05050000,0x01010000,0x000000,0x047
swctrlmapext_5g=0x00000000,0x00000000,0x00000000,0x000000,0x000
swctrlmapext_2g=0x00000000,0x00000000,0x00000000,0x000000,0x000
ltecxmux=0x77540
btc_mode=1
papdwar=4
cckdigfilttype=4
phy4350_ss_opt=1
#PCIe Header Values
#pciehdr_00=0x380f
#pciehdr_01=0x3800
#pciehdr_02=${boardtype}
#pciehdr_03=${vendid}
#pciehdr_04=0x021c
#pciehdr_05=0x1b7e
#pciehdr_06=0x0a00
#pciehdr_07=0x0000
#pciehdr_08=0x0000
#pciehdr_09=0x0000
#pciehdr_10=0x0000
#pciehdr_11=0x0000
#pciehdr_12=0x00d4
#pciehdr_13=0x253c
#pciehdr_14=0x2164
#pciehdr_15=0x3203
#pciehdr_16=0x3e5f
#pciehdr_17=0x9605
#pciehdr_18=0x9f2f
#pciehdr_19=0x79b6
#pciehdr_20=0x8080
#pciehdr_21=0x0c03
#pciehdr_22=0x4000
#pciehdr_23=0x3240
#pciehdr_24=0x5f00
#pciehdr_25=0x4df4
#pciehdr_26=0x8090
#pciehdr_27=0xee00
#pciehdr_28=0x8630
#pciehdr_29=0x0180
#pciehdr_30=0x002b
#pciehdr_31=0x0000
#pciehdr_32=0x0000
#pciehdr_33=0x0000
#pciehdr_34=0x0000
#pciehdr_35=0x0000
#pciehdr_36=0x0000
#pciehdr_37=0x0000
#pciehdr_38=0x0000
#pciehdr_39=0x0000
#pciehdr_40=0x0000
#pciehdr_41=0x0000
#pciehdr_42=0x8800
#pciehdr_43=0x030a
#pciehdr_44=0x0160
#pciehdr_45=0x0000
#pciehdr_46=0x0000
#pciehdr_47=0x0000
#pciehdr_48=${devid}
#pciehdr_49=0x8000
#pciehdr_50=0x0002
#pciehdr_51=0x0000
#pciehdr_52=0x3ff5
#pciehdr_53=0x1800
#pciehdr_54=0x0000
#pciehdr_55=0x0000
#pciehdr_56=0x0000
#pciehdr_57=0x0000
#pciehdr_58=0x0000
#pciehdr_59=0x0000
#pciehdr_60=0x0000
#pciehdr_61=0x0000
#pciehdr_62=0x0000
#pciehdr_63=0x0000

--------------030108080702040903080303--
