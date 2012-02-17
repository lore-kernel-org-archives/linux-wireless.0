Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:45850 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab2BQPlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 10:41:55 -0500
Received: by mail-bk0-f49.google.com with SMTP id jk13so3839212bkc.8
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 07:41:53 -0800 (PST)
Message-ID: <1329493309.21883.10.camel@cumari> (sfid-20120217_164217_639418_8E30D1B9)
Subject: linux-firmware: pull-request wl12xx 2012-02-17
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Feb 2012 17:41:49 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

Please pull the latest firmwares for the wl12xx driver.  These are new
firmwares that are necessary to use the latest driver version, in which
the host/fw API has changed.  We also updated our licence file.

Please let me know if there are any problems. 

The following changes since commit 38118a598df73d5a9fd72bf04910e8298db82a46:

  linux-firmware: brcm: add firmware for bcm43236 usb device (2012-02-11 19:20:10 +0000)

are available in the git repository at:
  git://github.com/TI-OpenLink/firmwares.git linux-firmware

Luciano Coelho (2):
      linux-firmware: ti-connectivity: update wl12xx firmwares
      linux-firmware: update ti-connectivity licence

 LICENCE.ti-connectivity             |  197 ++++++++---------------------------
 WHENCE                              |   30 ++++--
 ti-connectivity/wl127x-fw-4-mr.bin  |  Bin 0 -> 260852 bytes
 ti-connectivity/wl127x-fw-4-plt.bin |  Bin 0 -> 261892 bytes
 ti-connectivity/wl127x-fw-4-sr.bin  |  Bin 0 -> 276684 bytes
 ti-connectivity/wl128x-fw-4-mr.bin  |  Bin 0 -> 264904 bytes
 ti-connectivity/wl128x-fw-4-plt.bin |  Bin 0 -> 269424 bytes
 ti-connectivity/wl128x-fw-4-sr.bin  |  Bin 0 -> 284156 bytes
 8 files changed, 67 insertions(+), 160 deletions(-)
 create mode 100644 ti-connectivity/wl127x-fw-4-mr.bin
 create mode 100644 ti-connectivity/wl127x-fw-4-plt.bin
 create mode 100644 ti-connectivity/wl127x-fw-4-sr.bin
 create mode 100644 ti-connectivity/wl128x-fw-4-mr.bin
 create mode 100644 ti-connectivity/wl128x-fw-4-plt.bin
 create mode 100644 ti-connectivity/wl128x-fw-4-sr.bin

diff --git a/LICENCE.ti-connectivity b/LICENCE.ti-connectivity
index 085f6c7..da80b62 100644
--- a/LICENCE.ti-connectivity
+++ b/LICENCE.ti-connectivity
@@ -1,151 +1,46 @@
-Texas Instruments Incorporated
-Technology and Software Publicly Available
-Software (Object Code) License Agreement
-
-
-IMPORTANT - PLEASE READ THE FOLLOWING LICENSE AGREEMENT CAREFULLY. THIS IS
-       A LEGALLY BINDING AGREEMENT.  DO NOT DOWNLOAD THE LICENSED MATERIALS
-       UNLESS: (1) YOU ARE AUTHORIZED TO ACCEPT AND AGREE TO THE TERMS OF THIS
-       LICENSE AGREEMENT AND (2) YOU INTEND TO ENTER INTO AND TO BE BOUND BY
-       THE TERMS OF THIS AGREEMENT.
-
-This Software License Agreement ("Agreement") is a legal agreement between you
-       (either an individual or entity) and Texas Instruments Incorporated
-       ("TI").  The "Licensed Materials" subject to this Agreement include,
-       in whole or in part, the software programs that accompany this Agreement
-       and any "on-line" or electronic documentation associated with these
-       programs.  By installing, copying or otherwise using the Licensed
-       Materials you agree to abide by the terms of this Agreement.
-       If you choose not to accept or agree with these terms, do not download
-       or install the Licensed Materials.
-
-
-1. Object Code License.  TI hereby grants to you a limited, non-exclusive
-       license to reproduce and use the Licensed Materials provided to you in
-       object code format and to distribute an unlimited number of object or
-       executable copies of such Licensed Materials, provided that such object
-       or executable copies are used solely and exclusively on devices
-       manufactured by or for TI.
-
-2. Termination.  This license is effective until terminated.  Without prejudice
-       to any other rights, TI may terminate your right to use the Licensed
-       Materials under this Agreement if you fail to comply with the terms of
-       this Agreement.  In such event, you shall destroy all copies of the
-       Licensed Materials, including all portions and derivatives thereof.
-
-3. Intellectual Property Rights.  The Licensed Materials being provided to you
-       hereunder are being made publicly available by TI, even though they
-       contain copyrighted material of TI and its licensors, if applicable.
-       In no event may you alter, remove or destroy any copyright notice
-       included in the Licensed Materials.  To the extent that any of the
-       Licensed Materials are provided in binary or object code only, you may
-       not unlock, decompile, reverse engineer, disassemble or otherwise
-       translate such binary or object code to human-perceivable form. The
-       source code of such reverse engineered code may contain TI trade secret
-       and other proprietary information.  Further, nothing shall obligate TI
-       to provide you with source code for the Licensed Materials licensed to
-       you in binary or object code only under this Agreement.  TI reserves all
-       rights not specifically granted under this Agreement.
-
-4. Warranties and Limitations.  THE LICENSED MATERIALS ARE PROVIDED "AS IS". TI
-       MAKES NO WARRANTY OR REPRESENTATION, EXPRESS, IMPLIED OR STATUTORY,
-       INCLUDING ANY IMPLIED WARRANTIES OF MERCHANTIBILITY, FITNESS FOR A
-       PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS OF
-       RESPONSES, RESULTS AND LACK OF NEGLIGENCE.  TI DISCLAIMS ANY WARRANTY OF
-       TITLE, QUIET ENJOYMENT, QUIET POSESSION, AND NON-INFRINGEMENT OF ANY
-       THIRD PARTY INTELLECTUAL PROPERTY RIGHTS WITH REGARD TO THE LICENSED
-       MATERIALS OR USE OF THOSE MATERIALS.
-
-YOU ACKNOWLEDGE AND AGREE THAT THE LICENSED MATERIALS MAY NOT BE INTENDED FOR
-       PRODUCTION APPLICATIONS AND MAY CONTAIN IRREGULARITIES AND DEFECTS NOT
-       FOUND IN PRODUCTION SOFTWARE.  FURTHERMORE, YOU ACKNOWLEDGE AND AGREE
-       THAT THE LICENSED MATERIALS HAVE NOT BEEN TESTED OR CERTIFIED BY ANY
-       GOVERNMENT AGENCY OR INDUSTRY REGULATORY ORGANIZATION OR ANY OTHER THIRD
-       PARTY ORGANIZATION.  YOU AGREE THAT PRIOR TO USING, INCORPORATING OR
-       DISTRIBUTING THE LICENSED MATERIALS IN OR WITH ANY COMMERCIAL PRODUCT
-       THAT YOU WILL THOROUGHLY TEST THE PRODUCT AND THE FUNCTIONALITY OF THE
-       LICENSED MATERIALS IN OR WITH THAT PRODUCT AND BE SOLELY RESPONSIBLE FOR
-       ANY PROBLEMS OR FAILURES.
-
-IN NO EVENT SHALL TI, OR ANY APPLICABLE LICENSOR, BE LIABLE FOR ANY SPECIAL,
-       INDIRECT, INCIDENTAL, PUNITIVE OR CONSEQUENTIAL DAMAGES, HOWEVER CAUSED
-       ON ANY THEORY OF LIABILITY, ARISING IN ANY WAY OUT OF THIS AGREEMENT,
-       OR YOUR USE OF THE LICENSED MATERIALS, WHETHER OR NOT TI HAS BEEN
-       ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.  EXCLUDED DAMAGES INCLUDE,
-       BUT ARE NOT LIMITED TO, COST OF REMOVAL OR REINSTALLATION, OUTSIDE
-       COMPUTER TIME, LABOR COSTS, LOSS OR CORRUPTION OF DATA, LOSS OF
-       GOODWILL, LOSS OF PROFITS, LOSS OF SAVINGS, OR LOSS OF USE OR
-       INTERRUPTION OF BUSINESS OR ANY OTHER ECONOMIC LOSS.  IN NO EVENT WILL
-       TI'S AGGREGATE LIABILITY UNDER THIS AGREEMENT OR ARISING OUT OF YOUR USE
-       OF THE LICENSED MATERIALS EXCEED FIVE HUNDRED U.S. DOLLARS (US$500).
-
-Because some jurisdictions do not allow the exclusion or limitation of
-       incidental or consequential damages or limitation on how long an implied
-       warranty lasts, the above limitations or exclusions may not apply to
-       you.
-
-5. Export Control. Thesoftware programs and any "on-line" documentation as well
-       as any updates or upgrades to such software programs or documentation
-       may be subject to the export or import regulations of certain countries.
-       You agree to comply with all such regulations and acknowledge that you
-       have the responsibility to obtain any licenses or other authorizations
-       that may be required to export, re-export or import the Licensed
-       Materials.
-
-6. Governing Law, Jurisdiction and Severability.  This Agreement will be
-       governed by and interpreted in accordance with the laws of the State of
-       Texas, without reference to that state's conflict of laws principles.
-       This Agreement shall not be governed by the United Nations Convention on
-       Contracts for the International Sale of Goods, nor shall it be governed
-       by the Uniform Computer Information Transactions Act (UCITA).  Any
-       dispute arising out of or related to this Agreement will be brought in,
-       and each party consents to the exclusive jurisdiction and venue in the
-       state and federal courts sitting in Dallas Country, Texas. Each party
-       waives all defenses of lack of personal jurisdiction and forum
-       non-conveniens and agrees that process may be served on either party in
-       a manner authorized by applicable law or court rule.  If for any reason
-       a court of competent jurisdiction finds any provision of the Agreement
-       to be unenforceable, that provision will be enforced to the maximum
-       extent possible to effectuate the intent of the parties and the
-       remainder of the Agreement shall continue in full force and effect.
-
-7. PRC Provisions.  If you are located in the People's Republic of China ("PRC")
-       or if the Licensed Materials will be sent to the PRC, the following
-       provisions shall apply and shall supersede any other provisions in this
-       Agreement concerning the same subject matter as the following
-       provisions:
-
-       a.      Registration Requirements.  You shall be solely responsible for
-       performing all acts and obtaining all approvals that may be required in
-       connection with this Agreement by the government of the PRC, including
-       but not limited to registering pursuant to, and otherwise complying
-       with, the PRC Measures on the Administration of Software Products,
-       Management Regulations on Technology Import-Export, and Technology
-       Import and Export Contract Registration Management Rules. Upon receipt
-       of such approvals from the government authorities, you shall forward
-       evidence of all such approvals to TI for its records.  In the event that
-       you fail to obtain any such approval or registration, you shall be
-       solely responsible for any and all losses, damages or costs resulting
-       therefrom, and shall indemnify TI for all such losses, damages or costs.
-
-       b.      Governing Language.  This Agreement is written and executed in
-       the English language.  If a translation of this Agreement is required
-       for any purpose, including but not limited to registration of the
-       Agreement pursuant to any governmental laws, regulations or rules, you
-       shall be solely responsible for creating such translation.  Any
-       translation of this Agreement into a language other than English is
-       intended solely in order to comply with such laws or for reference
-       purposes, and the English language version shall be authoritative and
-       controlling.
-
-8. Entire Agreement.  This is the entire Agreement between you and TI and
-       supersedes any prior agreement between the parties related to the
-       subject matter of this Agreement. No amendment or modification of this
-       Agreement will be effective unless in writing and signed by a duly
-       authorized representative of TI.  You hereby warrant and represent that
-       you have obtained all authorizations and other applicable consents
-       required empowering you to enter into this Agreement.
-
-1
-TILAW-#236402v3
-
+   1 TECHNOLOGY AND SOFTWARE PUBLICLY AVAILABLE
+   2 SOFTWARE LICENSE
+   3
+   4 Copyright (c) 2011, Texas Instruments Incorporated.
+   5
+   6 All rights reserved.
+   7
+   8 Redistribution.
+   9
+  10 Redistribution and use in binary form, without modification, are
+  11 permitted provided that the following conditions are met:
+  12
+  13  * Redistributions must preserve existing copyright notices and reproduce
+  14   this license (including the above copyright notice and the disclaimer below)
+  15   in the documentation and/or other materials provided with the distribution.
+  16
+  17  * Neither the name of Texas Instruments Incorporated nor the names of
+  18    its suppliers may be used to endorse or promote products derived
+  19    from this software without specific prior written permission.
+  20
+  21  * No reverse engineering, decompilation, or disassembly of this
+  22    software is permitted.
+  23
+  24 Limited patent license.
+  25
+  26 Texas Instruments Incorporated grants a world-wide, royalty-free,
+  27 non-exclusive license under patents it now or hereafter owns or controls
+  28 to make, have made, use, import, offer to sell and sell ("Utilize") this
+  29 software, but solely to the extent that any such patent is necessary
+  30 to Utilize the software alone.  The patent license shall not apply to
+  31 any combinations which include this software.  No hardware per se is
+  32 licensed hereunder.
+  33
+  34 DISCLAIMER.
+  35
+  36 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  37 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  38 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  39 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  40 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  41 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  42 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  43 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  44 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  45 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  46 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
diff --git a/WHENCE b/WHENCE
index 804c91f..0596204 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1578,11 +1578,17 @@ File: wl1271-fw-2.bin
 File: wl1271-fw-ap.bin
 File: wl127x-fw-3.bin
 File: wl127x-fw-plt-3.bin
+File: wl127x-fw-4-sr.bin
+File: wl127x-fw-4-mr.bin
+File: wl127x-fw-4-plt.bin
 
 File: wl128x-fw.bin
 File: wl128x-fw-ap.bin
 File: wl128x-fw-3.bin
 File: wl128x-fw-plt-3.bin
+File: wl128x-fw-4-sr.bin
+File: wl128x-fw-4-mr.bin
+File: wl128x-fw-4-plt.bin
 
 File: wl127x-nvs.bin
 File: wl128x-nvs.bin
@@ -1592,15 +1598,21 @@ sl:   wl1271-nvs.bin -> wl127x-nvs.bin
 
 Licence: See LICENCE.ti-connectivity for details.
 
-       Station:      wl1271-fw.bin version 6.1.0.50.350
-       Station:      wl1271-fw-2.bin version 6.1.5.50.74
-       Station:      wl128x-fw.bin version 7.1.5.50.74
-       Access Point: wl1271-fw-ap.bin version 6.2.1.0.54
-       Access Point: wl128x-fw-ap.bin version 7.2.1.0.54
-       Station & Access Point: wl127x-fw-3.bin version Rev 6.3.0.0.77
-       PLT:                    wl127x-fw-3.bin version PLT 6.3.0.0.77
-       Station & Access Point: wl128x-fw-3.bin version Rev 7.3.0.0.77
-       PLT:                    wl128x-fw-3.bin version PLT 7.3.0.0.77
+       Station:                wl1271-fw.bin           6.1.0.50.350
+       Station:                wl1271-fw-2.bin         6.1.5.50.74
+       Station:                wl128x-fw.bin           7.1.5.50.74
+       Access Point:           wl1271-fw-ap.bin        6.2.1.0.54
+       Access Point:           wl128x-fw-ap.bin        7.2.1.0.54
+       Station & Access Point: wl127x-fw-3.bin         6.3.0.0.77
+       PLT:                    wl127x-fw-3.bin         6.3.0.0.77
+       Station & Access Point: wl128x-fw-3.bin         7.3.0.0.77
+       PLT:                    wl128x-fw-3.bin         7.3.0.0.77
+       Single-role:            wl127x-fw-4-sr.bin      6.3.5.0.98
+       Multi-role:             wl127x-fw-4-mr.bin      6.5.2.0.15
+       PLT:                    wl127x-fw-4-plt.bin     6.3.5.0.98
+       Single-role:            wl128x-fw-4-sr.bin      7.3.5.0.98
+       Multi-role:             wl128x-fw-4-mr.bin      7.5.2.0.15
+       PLT:                    wl128x-fw-4-plt.bin     7.3.5.0.98
 
 The nvs file includes two parts:
         - radio calibration
diff --git a/ti-connectivity/wl127x-fw-4-mr.bin b/ti-connectivity/wl127x-fw-4-mr.bin
new file mode 100644
index 0000000..6dd7f0e
Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-mr.bin differ
diff --git a/ti-connectivity/wl127x-fw-4-plt.bin b/ti-connectivity/wl127x-fw-4-plt.bin
new file mode 100644
index 0000000..b3b7d78
Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-plt.bin differ
diff --git a/ti-connectivity/wl127x-fw-4-sr.bin b/ti-connectivity/wl127x-fw-4-sr.bin
new file mode 100644
index 0000000..a9d8f96
Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-sr.bin differ
diff --git a/ti-connectivity/wl128x-fw-4-mr.bin b/ti-connectivity/wl128x-fw-4-mr.bin
new file mode 100644
index 0000000..64ca8fa
Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-mr.bin differ
diff --git a/ti-connectivity/wl128x-fw-4-plt.bin b/ti-connectivity/wl128x-fw-4-plt.bin
new file mode 100644
index 0000000..05f1317
Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-plt.bin differ
diff --git a/ti-connectivity/wl128x-fw-4-sr.bin b/ti-connectivity/wl128x-fw-4-sr.bin
new file mode 100644
index 0000000..e3e1000
Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-sr.bin differ

-- 
Cheers,
Luca.

