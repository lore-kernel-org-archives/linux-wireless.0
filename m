Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:36128 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZCRUnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 16:43:18 -0400
Received: by ewy9 with SMTP id 9so188002ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 13:43:14 -0700 (PDT)
Message-ID: <49C15A98.7000005@gmail.com> (sfid-20090318_214321_916306_5B4D6FC2)
Date: Wed, 18 Mar 2009 21:33:28 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
CC: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	David.Quan@atheros.com
Subject: Re: ids missing in ath5k ?
References: <49BC0DBE.90209@gmail.com> <49BC6C21.6020807@gmail.com> <49BC7117.1010107@gmail.com> <b6c5339f0903171418h6534a5a8w1ef8354f9571657a@mail.gmail.com> <20090317213639.GF6061@tesla>
In-Reply-To: <20090317213639.GF6061@tesla>
Content-Type: multipart/mixed;
 boundary="------------000909080405090105050302"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000909080405090105050302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Luis R. Rodriguez wrote:

> ACK on FF1A -- 802.11abg, NACK on the others, we don't at least have
> them in our own windows driver INF file.

0x168C, 0x0020 is:

ZyXEL M-302 Wireless G+ SuperSpeed PCI Card: http://www.zyxel.com/web/product_family_detail.php?PC1indexflag=20040520161256&CategoryGroupNo=06EDB83D-54BD-462D-A76B-EF0D3430A2DF&display=7041

driver: ftp://ftp2.zyxel.com/M-302/driver/M-302_2.0.0.zip

inf attached.


regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...

--------------000909080405090105050302
Content-Type: text/plain;
 name="net5513.inf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="net5513.inf"

;/*++
;
;Copyright (c) 2001-2005, All Rights Reserved
;
;Module Name:
;
;    net5513.inf
;
;Abstract:
;    INF file for installing M-102 802.11g Wireless Cardbus Card
;    INF file for installing M-302 802.11g Wireless PCI Adapter
;
;    Installs ar5513.sys (NDIS 5/5.1 driver) on NT platforms (2000, XP and greater)
;    Installs ar55139x.sys (NDIS 5 driver) on 9x platforms
;
;--*/

[Version]
Signature   = "$CHICAGO$"
Class       = Net
ClassGUID   = {4d36e972-e325-11ce-bfc1-08002be10318}
Provider    = %ATHEROS%
Compatible  = 1
DriverVer   = 09/12/2005,1.0.0.56
Catalogfile = net5513.cat

[Manufacturer]
%ATHEROS%     = Atheros

[ControlFlags]
ExcludeFromSelect = \  ;for win95 and legacy support
  PCI\VEN_168C&DEV_0020

[Atheros]
; DisplayName               Section                 DeviceID
; -----------               -------                 --------
; Generic
%ATHER.DeviceDesc.0020CB%  = ATHER_DEV_0020.ndi,    PCI\VEN_168C&DEV_0020&SUBSYS_34070308
%ATHER.DeviceDesc.0020PC%  = ATHER_DEV_0020.ndi,    PCI\VEN_168C&DEV_0020&SUBSYS_340E187E

; Windows 9X specific entries
[ATHER_DEV_0020.ndi]
AddReg          = ATHER_DEV_0020.id.reg, 5211.reg, ATHER.win.reg, 5212.abgcb.reg
CopyFiles       = ATHER.win.CopyFiles, DEFAULTDESTDIRS
DelFiles        = ATHER.DelIniFiles
DelReg          = 5211.DelReg

; Windows NT specific entries
[ATHER_DEV_0020.ndi.NT]
Characteristics = 0x84 ; NCF_PHYSICAL | NCF_HAS_UI
BusType         = 5
DelReg          = 5211.DelReg
AddReg          = 5211.reg, ATHER.reg, 5211.reg, 5212.abgcb.reg
CopyFiles       = ATHER.CopyFiles.nt, DEFAULTDESTDIRS
DelFiles        = ATHER.DelIniFiles

[ATHER_DEV_0020.ndi.NT.Services]
AddService      = AR5513, 2, ATHER.Service, common.EventLog

;----------------------------------------------------------------------------
; Win9x id registry sections
; These are not needed by NT

[ATHER_DEV_0020.id.reg]
HKR, Ndi, DeviceID, 0, "PCI\VEN_168C&DEV_0020"

;
; 5211 Enumerated Types
;
[5211.acb.reg]
HKR, ,                                  NetBand,                        0x00002,  "3"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  0

[5211.amp.reg]
HKR, ,                                  NetBand,                        0x00002,  "3"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  0

[5211.abcb.reg]
HKR, ,                                  NetBand,                        0x00002,  "7"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  1

[5211.abmp.reg]
HKR, ,                                  NetBand,                        0x00002,  "7"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  2

[5212.abgcb.reg]
HKR, ,                                  NetBand,                        0x00002,  "15"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  1

[5212.abgmp.reg]
HKR, ,                                  NetBand,                        0x00002,  "15"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  2

[5212.bgcb.reg]
HKR, ,                                  NetBand,                        0x00002,  "12"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  1

[5212.bgmp.reg]
HKR, ,                                  NetBand,                        0x00002,  "12"
HKR, CustomParams\Configurations,       NicType,                        0x10003,  2

;-----------------------------------------------------------------------------

;
; 5211 common
;
[5211.DelReg]
HKR,,NetBand
HKR,,ssid
HKR,,ssid2
HKR,,ssid3
HKR,,prefBssid1
HKR,,prefBssid2
HKR,,prefBssid3
HKR,,prefBssid4
HKR,Ndi\Params\tpc
HKR,,tpc
HKR,Ndi\Params\authTypeUseOnly
HKR,,authTypeUseOnly
HKR,,AdHocBand
HKR,,AwakeTimePerf
HKR,,beaconInterval
HKR,,bkScanEnable
HKR,,bssType
HKR,,ccode
HKR,,clist
HKR,,defaultKey
HKR,,EncryptionAlg
HKR,,FragThreshold
HKR,,HwTxRetries
HKR,,privacyInvoked
HKR,,QoS
HKR,,rateCtrlEnable
HKR,,RTSThreshold
HKR,,scanType
HKR,,SwTxRetryScale
HKR,,SmeEnable
HKR,,aifs
HKR,,cwmin

[5211.reg]

HKR, Ndi\params\MapRegisters,           ParamDesc,                      0,  %MapRegisters%
HKR, Ndi\params\MapRegisters,           default,                        0,  "256"
HKR, Ndi\params\MapRegisters,           min,                            0,  "32"
HKR, Ndi\params\MapRegisters,           max,                            0,  "512"
HKR, Ndi\params\MapRegisters,           step,                           0,  "8"
HKR, Ndi\params\MapRegisters,           base,                           0,  "10"
HKR, Ndi\params\MapRegisters,           type,                           0,  "int"

HKR, Ndi\params\NetworkAddress,         ParamDesc,                      0,  %NetworkAddress%
HKR, Ndi\params\NetworkAddress,         default,                        0,  ""
HKR, Ndi\params\NetworkAddress,         LimitText,                      0,  "12"
HKR, Ndi\params\NetworkAddress,         UpperCase,                      0,  "1"
HKR, Ndi\params\NetworkAddress,         optional,                       0,  "1"
HKR, Ndi\params\NetworkAddress,         type,                           0,  "edit"

HKR, Ndi\params\sleepMode,              ParamDesc,                      0,  %sleepMode%
HKR, Ndi\params\sleepMode,              Base,                           0,  "10"
HKR, Ndi\params\sleepMode,              default,                        0,  "2"
HKR, Ndi\params\sleepMode,              type,                           0,  "enum"
HKR, Ndi\params\sleepMode\enum,         "0",                            0,  %sleepModeOff%
HKR, Ndi\params\sleepMode\enum,         "2",                            0,  %sleepModeNormal%
HKR, Ndi\params\sleepMode\enum,         "1",                            0,  %sleepModeMax%

HKR, Ndi\params\shortPreamble,          ParamDesc,                      0,  %shortPreamble%
HKR, Ndi\params\shortPreamble,          Base,                           0,  "10"
HKR, Ndi\params\shortPreamble,          default,                        0,  "1"
HKR, Ndi\params\shortPreamble,          type,                           0,  "enum"
HKR, Ndi\params\shortPreamble\enum,     "1",                            0,  %shortPreambleEnable%
HKR, Ndi\params\shortPreamble\enum,     "0",                            0,  %shortPreambleDisable%

HKR, Ndi\params\radioEnable,            ParamDesc,                      0,  %radioEnable%
HKR, Ndi\params\radioEnable,            Base,                           0,  "10"
HKR, Ndi\params\radioEnable,            default,                        0,  "1"
HKR, Ndi\params\radioEnable,            type,                           0,  "enum"
HKR, Ndi\params\radioEnable\enum,       "1",                            0,  %radioEnableOn%
HKR, Ndi\params\radioEnable\enum,       "0",                            0,  %radioEnableOff%

HKR, CustomParams\Configurations,       MajorVersion,                   0x10003,  2
HKR, CustomParams\Configurations,       MinorVersion,                   0x10003,  0

HKR, CustomParams\Configurations,       SelectedConfigurationIndex,     0x10003,  0
HKR, CustomParams\Configurations,       SelectedConfigurationName,      0x00002,  "Default"

; Allow non admin uses to switch profiles
[5211.reg.security]
"D:ARAI(A;;GA;;;BA)(A;;GA;;;SY)(A;CI;GA;;;IU)"

;-----------------------------------------------------------------------------
; ATHER NT specific
;

[ATHER.reg]
HKR, Ndi,             Service,      0, "AR5513"
HKR, Ndi\Interfaces,  UpperRange,   0, "ndis5"
HKR, Ndi\Interfaces,  LowerRange,   0, "ethernet"

[ATHER.Service]
DisplayName     = %ATHER.Service.DispName%
ServiceType     = 1 ;%SERVICE_KERNEL_DRIVER%
StartType       = 3 ;%SERVICE_DEMAND_START%
ErrorControl    = 1 ;%SERVICE_ERROR_NORMAL%
ServiceBinary   = %12%\ar5513.sys
LoadOrderGroup  = NDIS

;-----------------------------------------------------------------------------
; ATHER NT/XP common
;
[common.EventLog]
AddReg = common.AddEventLog.reg

[common.AddEventLog.reg]
HKR, ,                  EventMessageFile,   0x00020000,   "%%SystemRoot%%\System32\netevent.dll"
HKR, ,                  TypesSupported,     0x00010001,   7

;----------------------------------------------------------------------------
; ATHER Win9x specific
;
[ATHER.win.reg]
HKR, ,                  DevLoader,          0,            "*ndis"
HKR, ,                  DeviceVxDs,         0,            "ar55139x.sys"
HKR, ,                  EnumPropPages,      0,            "netdi.dll,EnumPropPages"

HKR, Ndi\Interfaces,    DefUpper,           0,            "ndis3"
HKR, Ndi\Interfaces,    DefLower,           0,            "ethernet"
HKR, Ndi\Interfaces,    UpperRange,         0,            "ndis3"
HKR, Ndi\Interfaces,    LowerRange,         0,            "ethernet"


HKR, NDIS,              LogDriverName,      0,            "AR55139X"
HKR, NDIS,              MajorNdisVersion,   1,            03
HKR, NDIS,              MinorNdisVersion,   1,            0A

HKR, Ndi\Install,       ndis3,              0,            "ATHER.install"

;----------------------------------------------------------------------------
; Win9x Files to Copy
[ATHER.win.CopyFiles]
ar55139x.sys,,,2

;----------------------------------------------------------------------------
; NT Files to Copy
[ATHER.CopyFiles.nt]
ar5513.sys,,,2

[ATHER.DelIniFiles]
Athnic.ini,,,1

[SourceDisksNames]
;
; diskid = description[, [tagfile] [, <unused>, subdir]]
;
1 = %Atheros_Disk%,,,

;----------------------------------------------------------------------------
; Source Files
[SourceDisksFiles]
ar55139x.sys                 = 1,, ; on distribution disk 1
ar5513.sys                   = 1,, ; on distribution disk 1


[DestinationDirs]
ATHER.CopyFiles.nt           = 12
ATHER.win.CopyFiles          = 10,system32\drivers ; %SystemRoot%\system32\drivers
ATHER.DelIniFiles            = 10,system32\drivers ; %SystemRoot%\system32\drivers
DefaultDestDir               = 11

[DEFAULTDESTDIRS]
;


[Strings]
Atheros                      = "ZyXEL"
MapRegisters                 = "Map Registers"
NetworkAddress               = "Network Address"
sleepMode                    = "Power Save Mode"
sleepModeOff                 = "Off"
sleepModeNormal              = "Normal"
sleepModeMax                 = "Maximum"
shortPreamble                = "802.11b Preamble"
shortPreambleEnable          = "Long and Short"
shortPreambleDisable         = "Long only"
radioEnable                  = "Radio On/Off"
radioEnableOn                = "On"
radioEnableOff               = "Off"

Atheros_Disk                 = "ZyXEL Driver Disk 1"
ATHER.Service.DispName       = "ZyXEL 802.11g Wireless Adapter Service"
ATHER.DeviceDesc.0020CB      = "M-102 802.11g Wireless Cardbus Card"
ATHER.DeviceDesc.0020PC      = "M-302 802.11g Wireless PCI Adapter"

--------------000909080405090105050302--

